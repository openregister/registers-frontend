class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default


  module Exceptions
    class FrontendInvalidRegisterError < StandardError; end
  end

  module RegisterClientExtensions
    include Exceptions
    def refresh_data
      begin
        super
      rescue InvalidRegisterError
        # If register data is invalid we want to delete existing entries and records to force a full reload
        register_id = @data_store.instance_variable_get(:@register).id
        Record.where(register_id: register_id).destroy_all
        Entry.where(register_id: register_id).destroy_all
        raise Exceptions::FrontendInvalidRegisterError
      end
    end
  end

  RegistersClient::RegisterClient.module_eval do
    prepend RegisterClientExtensions
  end

  def perform(register)
    Delayed::Worker.logger.info("Updating #{register.name} in database")
    # Initialize client and download / update data
    register_client = @@registers_client.get_register(register.name.parameterize, register.register_phase.downcase, PostgresDataStore.new(register))
    register_client.refresh_data

    metadata_records = Record.where(register_id: register.id, entry_type: :system)
    fields = metadata_records.select { |record| record.key.start_with?("field:") }
    register.fields = fields.map { |field| field.data['field'] }.join(',')
    register.save
  end
end
