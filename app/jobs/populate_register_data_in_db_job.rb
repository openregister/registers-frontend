class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def perform(register)
    logger.info("Updating #{register.name} in database")

    RegisterDownloader.download(register)
    RegisterSearchResult.refresh
  rescue InvalidRegisterError
    logger.info "Root hash has changed for #{register.name}, so forcing a full reload instead"
    ForceFullRegisterDownloadJob.perform_now(register)
  end
end
