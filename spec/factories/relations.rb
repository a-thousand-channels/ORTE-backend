# frozen_string_literal: true

FactoryBot.define do
  factory :relation do
    relation_from_id { relation_from }
    relation_to_id { relation_to }
    rtype { 'all' }
    trait :invalid do
      relation_to_id { nil }
    end
    trait :changed do
      rtype { 'sequence' }
    end
  end
end
