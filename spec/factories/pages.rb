# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    is_published { false }
    in_menu { false }
    title { 'MyTitle' }
    teasertext { 'MyTeaserText' }
    fulltext { 'MyFullText' }
    footertext { 'MyFooterText' }
    ptype { 'Imprint' }
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
