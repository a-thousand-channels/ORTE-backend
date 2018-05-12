FactoryBot.define do
  factory :group do
    title "MyString"
    trait :invalid do
      title nil
    end
  end
end
