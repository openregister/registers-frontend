class ForceFullRegisterDownloadJob < ApplicationJob
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

      RegisterDownloader.download(register)
      RegisterSearchResult.refresh
    end
  end

private

  attr_reader :registers_client_manager
end
