namespace :registers_frontend do
  namespace :populate_db do
    desc "Add task to the queue to populate register data in the database"
    task fetch_later: :environment do
      Spina::Register.find_each do |register|
        PopulateRegisterDataInDbJob.perform_later(register)
      end
    end
    task fetch_now: :environment do
      Spina::Register.find_each do |register|
        PopulateRegisterDataInDbJob.perform_now(register)
      end
    end
  end
end
