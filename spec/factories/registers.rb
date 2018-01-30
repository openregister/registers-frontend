FactoryBot.define do
  factory :register do
    name { Faker::Name.name }
    register_phase { Faker::Name.name }
    authority { Faker::Name.name }
  end
end
