require 'rails_helper'

RSpec.describe PostgresDataStore do
  let(:register) { create(:register) }
  let(:data_store) { PostgresDataStore.new(register) }

  describe "the end_date value" do
    context "when the timezone is missing" do
      before do
        item = RegistersClient::Item.new('add-item	{"end-date":"2017-04-21T00:00:00","government-organisation":"D10","government-service":"1014","hostname":"benefitfraud-trial","start-date":"2017-04-21T00:00:00"}')

        entry = RegistersClient::Entry.new(
          "append-entry	user	1014	2017-09-01T10:45:48Z	sha-256:f9fbeb6e5851dae2a6c5df9c8b43a1120315d300dc0985e01ef0a08d1c7b74dd",
          123,
          "user"
        )

        data_store.add_item(item)
        data_store.append_entry(entry)
        data_store.after_load
      end

      it "is interpreted as UTC" do
        record = Record.find_by(key: 1014)
        expect(record.end_date).to eq(Time.utc(2017, 4, 21, 0, 0, 0))
      end
    end
  end
end
