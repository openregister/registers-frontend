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
        puts("populating register #{register.name}")
        PopulateRegisterDataInDbJob.perform_now(register)
      end
    end

    desc 'For local envs: Force a full redownload of a single register'
    task :force_full_register_download_now, [:slug] => [:environment] do |_t, args|
      register = Register.find_by(slug: args.slug)
      puts("starting full redownload of register #{register.name}")
      ForceFullRegisterDownloadJob.perform_now(register)
    end

    desc 'Add task to the queue to force a full redownload of a single register'
    task :force_full_register_download, [:slug] => [:environment] do |_t, args|
      register = Register.find_by(slug: args.slug)
      ForceFullRegisterDownloadJob.perform_later(register)
    end
  end
end
