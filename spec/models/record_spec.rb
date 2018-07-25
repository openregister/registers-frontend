require 'rails_helper'

RSpec.describe(Record) do
  describe("#status") do
    before do
      create(:record, key: "past", end_date: Time.utc(1990, 10, 2, 0, 0, 0))
      create(:record, key: "future", end_date: Time.utc(2999, 10, 2, 0, 0, 0))
      create(:record, key: "nil", end_date: nil)
    end

    context "archived" do
      it "includes only records with an end date in the past" do
        expect(Record.status("archived").pluck(:key)).to eq(%w(past))
      end
    end

    context "current" do
      it "includes records with an end date in the future" do
        expect(Record.status("current").pluck(:key)).to include("future")
      end

      it "excludes records with an end date in the past" do
        expect(Record.status("current").pluck(:key)).not_to include("past")
      end

      it "includes records with a nil end date" do
        expect(Record.status("current").pluck(:key)).to include("nil")
      end
    end

    context "all" do
      it "includes all records" do
        keys = Record.status("all").pluck(:key)
        expect(keys.sort).to eq(%w(future nil past))
      end
    end
  end
end
