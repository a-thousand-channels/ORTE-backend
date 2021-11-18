# frozen_string_literal: true

FactoryBot.define do
  factory :relation do
    relation_from_id { 1 }
    relation_to_id { 2 }
    rtype { 'all' }
    trait :invalid do
      relation_from_id { nil }
    end
    trait :changed do
      rtype { 'sequence' }
    end
  end
end
