FactoryBot.define do
  factory :record do
    entry_type "user"
    data("favourite-colour" => "blue")
    sequence :key do |n|
      "key-#{n}"
    end
    hash_value { Digest::SHA256.hexdigest(data.sort.to_h.to_json) }
    register
  end
end
