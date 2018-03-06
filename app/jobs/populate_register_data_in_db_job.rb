class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  module Exceptions
    class FrontendInvalidRegisterError < StandardError; end
  end

  def perform(register)
    Delayed::Worker.logger.info("Updating #{register.name} in database")
    begin
    # Initialize client and download / update data
      register_client = RegistersClientWrapper.registers_client.get_register(register.name.parameterize, register.register_phase.downcase, PostgresDataStore.new(register))
      register_url = register_client.instance_variable_get(:@register_url)
      register_client.refresh_data
    rescue InvalidRegisterError => e
    # If register data is invalid we want to delete existing entries and records to force a full reload
      ActiveRecord::Base.transaction do
        Record.where(register_id: register.id).delete_all
        Entry.where(register_id: register.id).delete_all
        register.root_hash = nil
        register.save
      end
      raise Exceptions::FrontendInvalidRegisterError, "#{register.name}: #{e}"
    end

    register.fields_array = Record.where(key: "register:#{register.slug}")
                                  .pluck("data -> 'fields' as fields")
                                  .first
    register.url = register_url
    register.save
  end
end
