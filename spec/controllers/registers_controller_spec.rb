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


    ObjectsFactory.new.create_register('country', 'Beta')
    ObjectsFactory.new.create_register('charity', 'Beta')
    ObjectsFactory.new.create_register('territory', 'Beta')

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

    stub_request(:get, 'https://www.registers.service.gov.uk/download-rsf/0')
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

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it { expect { subject }.to_not change(Register, :count) }
  end

  describe 'Request: GET #show. Descr: Check default behaviour. Params: --. Result: 10 rows' do
    subject { get :show, params: { id: 'country' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject
      expect(assigns(:records).length).to eq(10)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, default status. Result: 2 rows' do
    subject { get :show, params: { id: 'country', q: 'Germany', status: 'all' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, all status. Result: 2 rows' do
    subject { get :show, params: { id: 'country', q: 'Germany', status: 'all' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter. Params: Search param, default status. Result: 0 rows' do
    subject { get :show, params: { id: 'country', q: 'Random' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(0)
    end
  end

  describe 'Request: GET #show. Descr: Check with filter and cardinality N. Params: Search param. Result: 1 rows' do
    subject { get :show, params: { id: 'charity', q: '306', status: 'all' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).length).to eq(2)
    end
  end

  describe 'Request: GET #show. Descr: Afghanistan is first result' do
    subject { get :show, params: { id: 'country' } }

    it { is_expected.to be_successful }

    it { is_expected.to render_template :show }

    it do
      subject

      expect(assigns(:records).first.data['name']).to eq('Afghanistan')
    end
  end

  describe 'URL datatype linking' do
    it "links to external URL" do
      field = { "text" => "The website for a register entry.", "field" => "website", "phase" => "beta", "datatype" => "url", "cardinality" => "1" }
      field_value = "https://www.gov.uk/government/organisations/academy-for-justice-commissioning"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-organisation')).to eq("<a href=\"https://www.gov.uk/government/organisations/academy-for-justice-commissioning\">https://www.gov.uk/government/organisations/academy-for-justice-commissioning</a>")
    end
  end

  describe 'Register datatype linking' do
    it "does not link primary key field" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "string", "register" => "government-organisation", "cardinality" => "1" }
      field_value = "D13"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-organisation')).to eq("D13")
    end

    it "links register type fields" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "string", "register" => "government-organisation", "cardinality" => "1" }
      field_value = "D13"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-service', whitelist: %w(government-organisation))).to eq("<a href=\"/registers/government-organisation/records/D13\">D13</a>")
    end

    it "does not link if the register is not in the whitelist" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "string", "register" => "government-organisation", "cardinality" => "1" }
      field_value = "D13"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-service', whitelist: [])).to eq("D13")
    end
  end

  describe 'CURIE datatype linking' do
    it "resolves CURIE to record" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:D13"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-organisation', whitelist: %w(government-organisation))).to eq("<a href=\"/registers/government-organisation/records/D13\">government-organisation:D13</a>")
    end

    it "does not resolve CURIE to a record if the register doesn't contain records" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:D13"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-organisation', whitelist: [])).to eq("government-organisation:D13")
    end

    it "links one sided CURIE to register" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-domain', whitelist: %w(government-organisation))).to eq("<a href=\"/registers/government-organisation\">government-organisation:</a>")
    end

    it "doesn't link a one sided CURIE to the register if the register has no records" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:"
      expect(subject.field_link_resolver(field, field_value, register_slug: 'government-domain', whitelist: [])).to eq("government-organisation:")
    end
  end

  describe 'Cardinality N linking' do
    it "links each field value in cardinality N fields" do
      field = { "text" => "The classes that a charity falls into.", "field" => "charity-classes", "phase" => "discovery", "datatype" => "string", "register" => "charity-class", "cardinality" => "n" }
      field_value = %w[307 302 301 207 103 102 101]
      expect(subject.field_link_resolver(field, field_value, register_slug: 'charity', whitelist: %w(charity-class))).to eq("<a href=\"/registers/charity-class/records/307\">307</a>, <a href=\"/registers/charity-class/records/302\">302</a>, <a href=\"/registers/charity-class/records/301\">301</a>, <a href=\"/registers/charity-class/records/207\">207</a>, <a href=\"/registers/charity-class/records/103\">103</a>, <a href=\"/registers/charity-class/records/102\">102</a>, <a href=\"/registers/charity-class/records/101\">101</a>")
    end

    it "does not link field values if a cardinality N field references registers without records" do
      field = { "text" => "The classes that a charity falls into.", "field" => "charity-classes", "phase" => "discovery", "datatype" => "string", "register" => "charity-class", "cardinality" => "n" }
      field_value = %w[307 302 301 207 103 102 101]
      expect(subject.field_link_resolver(field, field_value, register_slug: 'charity', whitelist: [])).to eq("307, 302, 301, 207, 103, 102, 101")
    end
  end
end
