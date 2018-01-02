#TODO: Replace this with a scheduled job
if File.basename($0) == 'rails'
  PopulateRegisterDataInDbJob.perform_now
end
