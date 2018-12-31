FactoryBot.define do
  factory :iconset do
    title { "MyString" }
    text { "MyText" }
    image { "MyString" }
    trait :invalid do
      title { nil }
    end
  end
end
