# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { 'MyString' }
    subtitle { 'MyString' }
    teaser { 'MyText' }
    text { 'MyText' }
    published { false }
    state { 'MyString' }

    # Ensure locale is set before saving
    before(:create) { I18n.locale = I18n.default_locale }

    # Default to map for backward compatibility
    association :pageable, factory: :map

    trait :with_map do
      association :pageable, factory: :map
    end
    trait :with_place do
      association :pageable, factory: :place
    end
    # Default to map for backward compatibility
    trait :default do
      association :pageable, factory: :map
    end
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
    trait :with_images do
      published { true }

      transient do
        images_count { 3 }
      end

      after(:build) do |page, evaluator|
        evaluator.images_count.times do |i|
          file_path = Rails.root.join('spec', 'support', 'files', 'test.jpg')
          preview_value = i == 0
          page.images.build(attributes_for(:image, preview: preview_value)).file.attach(
            io: StringIO.new(File.read(file_path)),
            filename: "sample_image_#{i + 1}.jpg",
            content_type: 'image/jpeg'
          )
        end
      end
    end
  end
end
