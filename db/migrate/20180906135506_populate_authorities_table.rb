class PopulateAuthoritiesTable < ActiveRecord::Migration[5.2]
  def change
    # Create Authorities for existing registers even if gov-org register is not populated
    existing_authorities = Register.all.distinct.pluck(:authority).map { |a| { government_organisation_key: a } }
    Authority.create!(existing_authorities)

    PopulateAuthoritiesJob.perform_now
  end
end
