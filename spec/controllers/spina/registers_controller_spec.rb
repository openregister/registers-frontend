# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spina::RegistersController, type: :controller do
  routes { Spina::Engine.routes }

  before do
    country_data = File.read('./spec/support/country.rsf')
    register_beta_data = File.read('./spec/support/register_beta.rsf')
    register_alpha_data = File.read('./spec/support/register_alpha.rsf')
    register_discovery_data = File.read('./spec/support/register_discovery.rsf')
    register_charity_data = File.read('./spec/support/charity_card_n.rsf')

    @country_register = ObjectsFactory.new.create_register('country', 'Backlog', 'Ministry of Justice')
    @charity_register = ObjectsFactory.new.create_register('charity', 'Backlog', 'Ministry of Justice')

    allow(Spina::Register)
      .to receive(:find_by_slug!)
            .with('country')
            .and_return(@country_register)

    allow(Spina::Register)
      .to receive(:find_by_slug!)
            .with('charity')
            .and_return(@charity_register)

    # History stubs
    stub_request(:get, 'https://country.backlog.openregister.org/download-rsf')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'country.Backlog.openregister.org' })
      .to_return(status: 200, body: country_data, headers: {})

    stub_request(:get, 'https://charity.backlog.openregister.org/download-rsf')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'charity.Backlog.openregister.org' })
      .to_return(status: 200, body: register_charity_data, headers: {})

    # Index stubs
    stub_request(:get, 'https://register.beta.openregister.org/download-rsf')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'register.beta.openregister.org' })
      .to_return(status: 200, body: register_beta_data, headers: {})

    stub_request(:get, 'https://register.alpha.openregister.org/download-rsf')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'register.alpha.openregister.org' })
      .to_return(status: 200, body: register_alpha_data, headers: {})

    stub_request(:get, 'https://register.discovery.openregister.org/download-rsf')
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => 'register.discovery.openregister.org', 'User-Agent' => 'rest-client/2.0.2 (darwin15.6.0 x86_64) ruby/2.4.2p198' })
      .to_return(status: 200, body: register_discovery_data, headers: {})
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

      expect(assigns(:records).length).to eq(1)
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

      expect(assigns(:records).length).to eq(1)
    end
  end
end
