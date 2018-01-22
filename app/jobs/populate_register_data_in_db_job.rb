class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def perform(register)
    Delayed::Worker.logger.info("Updating #{register.name} in database")
    # Initialize client and download / update data
    register_client = @@registers_client.get_register(register.name.parameterize, register.register_phase.downcase, PostgresDataStore.new(register))
    register_client.refresh_data

    metadata_records = Record.where(spina_register_id: register.id, entry_type: :system)
    fields = metadata_records.select{|record| record.key.start_with?("field:")}
    register.fields = fields.map { |field| field.data['field'] }.join(',')
    register.save
  end
end
