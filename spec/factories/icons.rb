FactoryBot.define do
  factory :icon do
    title { "MyString" }
    image { "MyString" }
    iconset
    trait :invalid do
      iconset { nil }
    end
  end
end
