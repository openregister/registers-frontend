class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def perform(register)
    logger.info("Updating #{register.name} in database")

    RegisterDownloader.download(register)
    RegisterSearchResult.refresh
  rescue InvalidRegisterError
    logger.info "Failed to update #{register.name}, so forcing a full reload instead"
    RedownloadRegisterJob.perform_now(register)
  end
end
