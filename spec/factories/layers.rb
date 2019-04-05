FactoryBot.define do
  factory :layer do
    title { "MyString" }
    text { "MyString" }
    published { false }
    map
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { "OtherTitle" }
    end
  end
end
