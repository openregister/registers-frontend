class ForceFullRegisterDownloadJob < ApplicationJob
  queue_as :default

  # Redownload all the entries in a register
  def perform(register)
    ActiveRecord::Base.transaction do
      Delayed::Worker.logger.info("Removing existing #{register.name} records from database")

      Record.where(register_id: register.id).delete_all
      Entry.where(register_id: register.id).delete_all
      register.save

      Delayed::Worker.logger.info("Updating #{register.name} in database")

      RegisterDownloader.download(register)
      RegisterSearchResult.refresh
    end
  end

private

  attr_reader :registers_client_manager
end
