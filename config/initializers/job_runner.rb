#TODO: Replace this with a scheduled job
unless Rails.env.test? || !ActiveRecord::Base.connection.table_exists?('spina_registers') || File.basename($0) == 'rake'
  PopulateRegisterDataInDbJob.perform_now
end
