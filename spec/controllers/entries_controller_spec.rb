# frozen_string_literal: true

require 'rails_helper'


RSpec.describe EntriesController, type: :controller do
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

    stub_request(:get, 'https://registers.service.gov.uk/download-rsf/0')
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

  describe 'Request: GET #index. Descr: Check register consistency. Params: --. Result: Success' do
    subject { get :index, params: { register_id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it { expect { subject }.to_not change(Register, :count) }
  end

  describe 'Request: GET #index. Descr: Check default behaviour. Params: --. Result: 100 rows' do
    subject { get :index, params: { register_id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(100)
    end
  end

  describe 'Request: GET #index. Descr: Check with filter. Params: Search param. Result: 4 rows' do
    subject { get :index, params: { register_id: 'country', q: 'GM' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(4)
    end
  end

  describe 'Request: GET #index. Descr: Check with filter. Params: Search param (changed field). Result: 1 rows' do
    subject { get :index, params: { register_id: 'territory', q: 'Ceuta' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject
      expect(assigns(:entries_with_items).length).to eq(1)
    end
  end

  describe 'Request: GET #index. Descr: Check with filter. Params: Search param. Result: No matches' do
    subject { get :index, params: { register_id: 'country', q: 'random' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(0)
    end
  end

  describe 'Request: GET #index. Descr: Check with filter and cardinality N. Params: Search param. Result: 2 rows' do
    subject { get :index, params: { register_id: 'charity', q: '306' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject

      expect(assigns(:entries_with_items).length).to eq(2)
    end
  end

  describe 'History should show current and previous value' do
    subject { get :index, params: { register_id: 'country' } }

    it { is_expected.to have_http_status :success }

    it { is_expected.to render_template :index }

    it do
      subject
      expect(assigns(:entries_with_items).first[:current_record].data['official-name']).to eq("The Republic of Côte D’Ivoire")
      expect(assigns(:entries_with_items).first[:previous_record].data['official-name']).to eq("The Republic of Cote D'Ivoire")
      expect(assigns(:entries_with_items).first[:updated_fields]).to eq(["official-name"])
    end
  end
end
