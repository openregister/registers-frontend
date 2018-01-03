#TODO: Replace this with a scheduled job
if File.basename($0) == 'rails'
  Spina::Register.find_each do |register|
    puts("Updating #{register.name} in database")
    PopulateRegisterDataInDbJob.perform_now(register)
  end
end
