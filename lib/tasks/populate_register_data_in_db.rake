# frozen_string_literal: true

namespace :registers_frontend do
  namespace :populate_db do

    desc 'Add task to the queue to populate register data in the database'
    task fetch_later: :environment do
      Spina::Register.find_each do |register|
        PopulateRegisterDataInDbJob.perform_later(register)
      end
    end

    desc 'For local envs: Add task to the queue to populate register data in the database'
    task fetch_now: :environment do
      Spina::Register.find_each do |register|
        begin
          PopulateRegisterDataInDbJob.perform_now(register)
        rescue StandardError => e
          puts "[Error] #{e.message}"
          next
        end
      end
    end
  end
end
