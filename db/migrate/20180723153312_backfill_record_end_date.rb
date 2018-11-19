class BackfillRecordEndDate < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    # This takes about 7m to run
    Record.where("data->> 'end-date' is not null").find_each do |record|
      end_date_str = record.data["end-date"]
      unless end_date_str.nil?
        end_date = ISO8601::DateTime.new(end_date_str).to_time.utc
        record.end_date = end_date
        record.save!
      end
    end
  end
end
