# frozen_string_literal: true

namespace :registers_frontend do
  namespace :populate_db do
    desc 'Add task to the queue to populate register data in the database'
    task fetch_later: :environment do
      Register.where.not(register_phase: 'Backlog').find_each do |register|
        PopulateRegisterDataInDbJob.perform_later(register)
      end
    end

    desc 'For local envs: populate register data in the database now'
    task fetch_now: :environment do
      Register.where.not(register_phase: 'Backlog').find_each do |register|
        begin
          retries ||= 0
          puts("populating register #{register.name}")
          PopulateRegisterDataInDbJob.perform_now(register)
        rescue PopulateRegisterDataInDbJob::Exceptions::FrontendInvalidRegisterError => e
          retry if (retries += 1) < 2
          puts "[Error] #{e.message}"
          next
        rescue StandardError => e
          puts "[Error] #{e.message}"
          next
        end
      end
    end
  end
end
