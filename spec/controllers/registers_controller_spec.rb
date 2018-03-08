# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistersController, type: :controller do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    register_beta_data = File.read('./spec/support/register_beta.rsf')
    register_alpha_data = File.read('./spec/support/register_alpha.rsf')
    register_discovery_data = File.read('./spec/support/register_discovery.rsf')
    register_charity_data = File.read('./spec/support/charity_card_n.rsf')
    register_territory_data = File.read('./spec/support/territory.rsf')
    country_proof = File.read('./spec/support/country_proof.json')
    country207 = File.read('./spec/support/country_207.rsf')
    charity10 = File.read('./spec/support/charity_10.rsf')
    territory80 = File.read('./spec/support/territory_80.rsf')
    charity_proof = File.read('./spec/support/charity_proof.json')
    territory_proof = File.read('./spec/support/territory_proof.json')

    RegistersClientWrapper.class_variable_set(:@@registers_client, RegistersClient::RegisterClientManager.new)

    ObjectsFactory.new.create_register('country', 'Beta', 'D587')
    ObjectsFactory.new.create_register('charity', 'Beta', 'D587')
    ObjectsFactory.new.create_register('territory', 'Beta', 'D587')

    # RSF stubs
    stub_request(:get, 'https://country.register.gov.uk/download-rsf/0')
    .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
    .to_return(status: 200, body: country_data, headers: {})

    stub_request(:get, 'https://charity.register.gov.uk/download-rsf/0')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
      .to_return(status: 200, body: register_charity_data, headers: {})

    stub_request(:get, 'https://territory.register.gov.uk/download-rsf/0')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
      .to_return(status: 200, body: register_territory_data, headers: {})

  # Index stubs
    stub_request(:get, 'https://register.register.gov.uk/download-rsf/0')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
      .to_return(status: 200, body: register_beta_data, headers: {})

    stub_request(:get, 'https://register.alpha.openregister.org/download-rsf/0')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
      .to_return(status: 200, body: register_alpha_data, headers: {})

    stub_request(:get, 'https://register.cloudapps.digital/download-rsf/0')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate' })
      .to_return(status: 200, body: register_discovery_data, headers: {})

    stub_request(:get, "https://country.register.gov.uk/download-rsf/207").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country207, headers: {})

    stub_request(:get, "https://charity.register.gov.uk/download-rsf/10").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'charity.register.gov.uk' }).
      to_return(status: 200, body: charity10, headers: {})

    stub_request(:get, "https://territory.register.gov.uk/download-rsf/80").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'territory.register.gov.uk' }).
      to_return(status: 200, body: territory80, headers: {})

    stub_request(:get, "https://country.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.register.gov.uk' }).
      to_return(status: 200, body: country_proof, headers: {})

    stub_request(:get, "https://charity.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'charity.register.gov.uk' }).
      to_return(status: 200, body: charity_proof, headers: {})

    stub_request(:get, "https://territory.register.gov.uk/proof/register/merkle:sha-256").
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'territory.register.gov.uk' }).
      to_return(status: 200, body: territory_proof, headers: {})

    Register.find_each do |register|
      PopulateRegisterDataInDbJob.perform_now(register)
    end
  end

  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'Request: GET #show. Descr: Check register consistency. Params: --. Result: Success' do
    subject { get :show, params: { id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it { expect { subject }.to_not change(Register, :count) }
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

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, default status. Result: 2 rows' do
    subject { get :show, params: { id: 'country', q: 'Germany', status: 'all' } }

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
    subject { get :show, params: { id: 'charity', q: '306', status: 'all' } }

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

  describe 'Request: GET #show. Descr: Sort by start date descending where some values are nil should show nil values last' do
    subject { get :show, params: { id: 'country', sort_by: 'start-date', sort_direction: 'desc' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :show }

    it do
      subject
      expect(assigns(:records).first.data['start-date']).to eq('2011-07-09')
      expect(assigns(:records).last.data['start-date']).to be_nil
    end
  end
end
