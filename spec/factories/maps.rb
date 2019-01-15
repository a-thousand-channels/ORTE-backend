FactoryBot.define do
  factory :map do
    title { "MyString" }
    text { "MyString" }
    published { false }
    group
    trait :invalid do
      title { nil }
    end
    trait :update do
      title { "MyNewString" }
    end
  end
end
