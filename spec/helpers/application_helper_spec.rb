require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'URL datatype linking' do
    it "links to external URL" do
      field = { "text" => "The website for a register entry.", "field" => "website", "phase" => "beta", "datatype" => "url", "cardinality" => "1" }
      field_value = "https://www.gov.uk/government/organisations/academy-for-justice-commissioning"
      expect(helper.field_link_resolver(field, field_value, 'government-organisation')).to eq("<a href=\"https://www.gov.uk/government/organisations/academy-for-justice-commissioning\">https://www.gov.uk/government/organisations/academy-for-justice-commissioning</a>")
    end
  end

  describe 'Register datatype linking' do
    it "does not link primary key field" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "string", "register" => "government-organisation", "cardinality" => "1" }
      field_value = "D13"
      expect(helper.field_link_resolver(field, field_value, 'government-organisation')).to eq("D13")
    end

    it "links register type fields" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "string", "register" => "government-organisation", "cardinality" => "1" }
      field_value = "D13"
      expect(helper.field_link_resolver(field, field_value, 'government-service')).to eq("<a href=\"/registers/government-organisation/records/D13\">D13</a>")
    end
  end

  describe 'CURIE datatype linking' do
    it "resolves CURIE to record" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:D13"
      expect(helper.field_link_resolver(field, field_value, 'government-organisation')).to eq("<a href=\"/registers/government-organisation/records/D13\">government-organisation:D13</a>")
    end

    it "links one sided CURIE to register" do
      field = { "text" => "The unique code for a government organisation.", "field" => "government-organisation", "phase" => "beta", "datatype" => "curie", "cardinality" => "1" }
      field_value = "government-organisation:"
      expect(helper.field_link_resolver(field, field_value, 'government-organisation')).to eq("<a href=\"/registers/government-organisation\">government-organisation:</a>")
    end
  end

  describe 'Cardinality N linking' do
    it "links each field value in cardinality N fields" do
      field = { "text" => "The classes that a charity falls into.", "field" => "charity-classes", "phase" => "discovery", "datatype" => "string", "register" => "charity-class", "cardinality" => "n" }
      field_value = %w[307 302 301 207 103 102 101]
      expect(helper.field_link_resolver(field, field_value, 'charity')).to eq("<a href=\"/registers/charity-class/records/307\">307</a>, <a href=\"/registers/charity-class/records/302\">302</a>, <a href=\"/registers/charity-class/records/301\">301</a>, <a href=\"/registers/charity-class/records/207\">207</a>, <a href=\"/registers/charity-class/records/103\">103</a>, <a href=\"/registers/charity-class/records/102\">102</a>, <a href=\"/registers/charity-class/records/101\">101</a>")
    end
  end
end
