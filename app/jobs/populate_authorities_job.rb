class PopulateAuthoritiesJob < ApplicationJob
  queue_as :default

  def perform
    Register.find_by(slug: 'government-organisation')&.records&.where(entry_type: 'user')&.find_each do |r|
      a = Authority.find_or_initialize_by(government_organisation_key: r.key)
      a.name = r.data['name']
      a.save
    end
  end
end
