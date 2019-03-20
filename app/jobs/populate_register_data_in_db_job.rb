class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def perform(register)
    logger.info("Updating #{register.name} in database")
    RegisterDownloader.download(register)
    RegisterSearchResult.refresh
  end
end
