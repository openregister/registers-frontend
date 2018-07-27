class RedownloadRegisterJob < ApplicationJob
  queue_as :default

  class FrontendInvalidRegisterError < StandardError; end

  # Redownload all the entries in a register
  def perform(register)
    ActiveRecord::Base.transaction do
      logger.info("Removing existing #{register.name} records from database")

      Record.where(register_id: register.id).delete_all
      Entry.where(register_id: register.id).delete_all
      register.root_hash = nil
      register.save

      logger.info("Updating #{register.name} in database")

      begin
        RegisterDownloader.download(register)
      rescue InvalidRegisterError => e
        logger.error("Failed to redownload #{register.name}")
        raise FrontendInvalidRegisterError.new("#{register.name}: #{e}")
      end

      RegisterSearchResult.refresh
    end
  end

private

  attr_reader :registers_client_manager
end
