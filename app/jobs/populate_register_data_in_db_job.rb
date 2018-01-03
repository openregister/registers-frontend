class PopulateRegisterDataInDbJob < ApplicationJob
  queue_as :default
  rescue_from(StandardError) do |exception|
    puts("Updating register failed with #{exception}")
   end


def perform(register)
    PopulateDatabase.new(register).populate_register   
  end
end
