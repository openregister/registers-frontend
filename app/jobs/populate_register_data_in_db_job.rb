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
    register_data = @registers_client.get_register(register.name.parameterize, register.register_phase.downcase, PostgresDataStore.new(register))
    register_data.refresh_data

    register.fields = register_data.get_field_definitions.map { |field| field.item.value['field'] }.join(',')
    register.save
  end

  def perform(*)
    Spina::Register.find_each do |register|
      logger.info("Updating #{register.name} in database")
      begin
        populate_register(register)
      rescue StandardError => e
        logger.error("failed to populate register #{register.name} due to exception #{e}")
        next
      end
    end
  end
end
