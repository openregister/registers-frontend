# frozen_string_literal: true

FactoryBot.define do
  factory :support do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    message { Faker::Lorem.paragraph }
    subject { Faker::Lorem.sentence }
  end
end
