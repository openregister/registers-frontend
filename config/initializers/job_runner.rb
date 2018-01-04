#TODO: Replace this with a scheduled job
if File.basename($0) == 'rails'
  Spina::Register.find_each do |register|
    PopulateRegisterDataInDbJob.perform_later(register)
  end
end
