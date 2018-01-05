# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistersController, type: :controller do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    register_beta_data = File.read('./spec/support/register_beta.rsf')
    register_alpha_data = File.read('./spec/support/register_alpha.rsf')
    register_discovery_data = File.read('./spec/support/register_discovery.rsf')
    register_charity_data = File.read('./spec/support/charity_card_n.rsf')
    register_territory_data = File.read('./spec/support/territory_short.rsf')

    ObjectsFactory.new.create_register('country', 'Beta', 'Ministry of Justice')
    ObjectsFactory.new.create_register('charity', 'Beta', 'Ministry of Justice')
    ObjectsFactory.new.create_register('territory', 'Beta', 'Ministry of Justice')

    # RSF stubs
    stub_request(:get, 'https://country.beta.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: country_data, headers: {})

  stub_request(:get, 'https://charity.beta.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: register_charity_data, headers: {})

  stub_request(:get, 'https://territory.beta.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: register_territory_data, headers: {})

  # Index stubs
  stub_request(:get, 'https://register.beta.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate'})
    .to_return(status: 200, body: register_beta_data, headers: {})

  stub_request(:get, 'https://register.alpha.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate'})
    .to_return(status: 200, body: register_alpha_data, headers: {})

  stub_request(:get, 'https://register.discovery.openregister.org/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate'})
    .to_return(status: 200, body: register_discovery_data, headers: {})

  stub_request(:get, "https://country.beta.openregister.org/download-rsf/207").
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'country.beta.openregister.org'}).
    to_return(status: 200, body: "", headers: {})

  stub_request(:get, "https://charity.beta.openregister.org/download-rsf/10").
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'charity.beta.openregister.org'}).
    to_return(status: 200, body: "", headers: {})

  stub_request(:get, "https://territory.beta.openregister.org/download-rsf/3").
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'territory.beta.openregister.org'}).
    to_return(status: 200, body: "", headers: {})

    PopulateRegisterDataInDbJob.perform_now


  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end



  describe 'Request: GET #history. Descr: Check register consistency. Params: --. Result: Success' do
    subject { get :history, params: { id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it { expect { subject }.to_not change(Spina::Register, :count) }
  end

  describe 'Request: GET #history. Descr: Check default behaviour. Params: --. Result: 100 rows' do
    subject { get :history, params: { id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(100)
    end
  end

  describe 'Request: GET #history. Descr: Check with filter. Params: Search param. Result: 4 rows' do
    subject { get :history, params: { id: 'country', q: 'GM' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(4)
    end
  end

  describe 'Request: GET #history. Descr: Check with filter. Params: Search param (changed field). Result: 1 rows' do
    subject { get :history, params: { id: 'territory', q: 'The New' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it do
      subject
      expect(assigns(:entries_with_items).length).to eq(1)
    end
  end

  describe 'Request: GET #history. Descr: Check with filter. Params: Search param. Result: No matches' do
    subject { get :history, params: { id: 'country', q: 'random' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(0)
    end
  end

  describe 'Request: GET #history. Descr: Check with filter and cardinality N. Params: Search param. Result: 2 rows' do
    subject { get :history, params: { id: 'charity', q: '306' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :history }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Check register consistency. Params: --. Result: Success' do
    subject { get :show, params: { id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it { expect { subject }.to_not change(Spina::Register, :count) }
  end

  describe 'Request: GET #show. Descr: Check default behaviour. Params: --. Result: 100 rows' do
    subject { get :show, params: { id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do

      subject
      expect(assigns(:records).length).to eq(100)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, default status. Result: 1 rows' do
    subject { get :show, params: { id: 'country', q: 'Germany' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, all status. Result: 2 rows' do
    subject { get :show, params: { id: 'country', q: 'Germany', status: 'all' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, default status. Result: 0 rows' do
    subject { get :show, params: { id: 'country', q: 'Random' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(0)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter and cardinality N. Params: Search param. Result: 1 rows' do
    subject { get :show, params: { id: 'charity', q: '306' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Sort by Name ascending. Result: Afghanistan is first result' do
    subject { get :show, params: { id: 'country', sort_by: 'name', sort_direction: 'asc' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).first.data['name']).to eq('Afghanistan')
    end
  end

  describe 'Request: GET #show. Descr: Sort by name descending. Result: Zimbabwe is first result' do
    subject { get :show, params: { id: 'country', sort_by: 'name', sort_direction: 'desc' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).first.data['name']).to eq('Zimbabwe')
    end
  end

  describe 'Request: GET #show. Descr: Sort by start date descending where some values are nil' do
    subject { get :show, params: { id: 'country', sort_by: 'start-date', sort_direction: 'desc' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject
      expect(assigns(:records).first.data['start-date']).to be_nil
      expect(assigns(:records).last.data['start-date']).to be_nil
    end
  end
end
