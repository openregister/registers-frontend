FactoryBot.define do
  factory :authority do
    name { Faker::Name.name }
    government_organisation_key { Faker::Number.number }
  end
end
