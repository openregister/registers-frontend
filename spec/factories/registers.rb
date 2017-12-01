FactoryBot.define do
  factory :spina_register, class: Spina::Register do
    name { Faker::Name.name }
    register_phase { Faker::Name.name }
    authority { Faker::Name.name }
  end
end