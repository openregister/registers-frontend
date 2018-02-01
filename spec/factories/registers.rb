FactoryBot.define do
  factory :register, class: Register do
    name { Faker::Name.name }
    register_phase { Faker::Name.name }
    authority { Faker::Name.name }
  end
end
