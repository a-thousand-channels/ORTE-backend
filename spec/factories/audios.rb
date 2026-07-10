# frozen_string_literal: true

FactoryBot.define do
  factory :audio do
    title { Faker::GreekPhilosophers.name }
    subtitle { Faker::GreekPhilosophers.quote }
    licence { Faker::Hipster.word }
    source { Faker::Book.publisher }
    creator { Faker::Book.author }
    transcription { Faker::GreekPhilosophers.quote }
    association :audioable, factory: :place
    sorting { Faker::Number.between(from: 1, to: 10) }
    preview { false }
    locale { Faker::Nation.language }
    trait :with_file do
      after(:build) do |audio|
        audio.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.mp3')),
          filename: 'test.mp3',
          content_type: 'audio/mpeg'
        )
      end
    end
    trait :without_file do
      file { [] }
    end
    trait :with_wrong_fileformat do
      after(:build) do |audio|
        audio.file.attach(
          io: File.open(Rails.root.join('spec/support/files/test.txt')),
          filename: 'test.txt',
          content_type: 'image/jpeg'
        )
      end
    end
    trait :invalid do
      title { nil }
      audioable { nil }
      file { [] }
    end
    trait :changed do
      title { 'OtherTitle' }
    end
  end
end
