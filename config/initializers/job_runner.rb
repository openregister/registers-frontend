unless Rails.env.test?
  PopulateRegisterDataInDbJob.perform_now
end
