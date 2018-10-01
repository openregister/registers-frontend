namespace :registers_frontend do
  namespace :populate_authorities do
    desc "Add task to queue: Populate Authorities using Government Organisation register."
    task fetch_later: :environment do
      PopulateAuthoritiesJob.perform_later
    end

    desc "Perform now: Populate Authorities using Government Organisation register."
    task fetch_now: :environment do
      PopulateAuthoritiesJob.perform_now
    end
  end
end
