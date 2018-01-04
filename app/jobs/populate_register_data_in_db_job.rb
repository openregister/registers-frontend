class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default

  def perform(register)
    PopulateDatabase.new(register).populate_register
  end
end
