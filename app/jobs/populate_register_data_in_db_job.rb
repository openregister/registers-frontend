class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def initialize
    @registers_client ||= RegistersClient::RegisterClientManager.new(cache_duration: 60)
  end

  def bulk_remove_existing_records(register, entry_type, record_keys)
    unless record_keys.empty?
      Record.where(spina_register_id: register.id, entry_type: entry_type, key: record_keys).delete_all
    end
  end

  def bulk_save(entries, records)
    Entry.import!(entries)
    Record.import!(records)
  end

  def populate_register(register)
    register_data = @registers_client.get_register(register.name.parameterize, register.register_phase.downcase)
    register_data.refresh_data
    populate_data(register, register_data, 'user')
    populate_data(register, register_data, 'system')

    register.fields = register_data.get_field_definitions.map { |field| field.item.value['field'] }.join(',')
    register.save
  end

  def populate_data(register, register_data, entry_type)
    entries = []
    records = []
    count = 0

    latest_entry = Entry.where(spina_register_id: register.id, entry_type: entry_type).order(:entry_number).reverse_order.first
    latest_entry_number = latest_entry.nil? ? 0 : latest_entry.entry_number

    (entry_type == 'user' ? register_data.get_records_with_history(latest_entry_number) : register_data.get_metadata_records_with_history(latest_entry_number)).each do |record|
      previous_entry_number = nil

      record[:records].each_with_index do |value, idx|
        count += 1
        new_entry = Entry.new(spina_register: register, data: value.item.value, timestamp: value.entry.timestamp, hash_value: value.item.hash, entry_number: value.entry.entry_number, previous_entry_number: previous_entry_number, entry_type: entry_type, key: value.entry.key)
        entries.push(new_entry)

        if idx == record[:records].length - 1 # The last entry is the record
          records.push(Record.new(spina_register: register, data: value.item.value, timestamp: value.entry.timestamp, hash_value: value.item.hash, entry_number: value.entry.entry_number, entry_type: entry_type, key: value.entry.key))
        end

        previous_entry_number = value.entry.entry_number
      end

      next unless (count % 1000).zero?
      if latest_entry_number.positive?
        Record.transaction do
          bulk_remove_existing_records(register, entry_type, records.map(&:key))
          bulk_save(entries, records)
        end
        else
          bulk_save(entries, records)
      end
      entries = []
      records = []
    end

    # Remaining objects less than 1000
    if records.count.positive?
      if latest_entry_number.positive?
        Record.transaction do
          bulk_remove_existing_records(register, entry_type, records.map(&:key))
          bulk_save(entries, records)
        end
      else
        bulk_save(entries, records)
      end
    end
  end

  def perform(*)
    Spina::Register.find_each do |register|
      logger.info("Updating #{register.name} in database")
      begin
      populate_register(register)
    rescue => e
      logger.error("failed to populate register #{register.name} due to exception #{e}")
      next
      end
    end
  end
end
