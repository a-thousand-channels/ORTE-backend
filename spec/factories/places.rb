FactoryBot.define do
  factory :place do
    title { "MyString" }
    teaser { "MyText" }
    text { "MyText" }
    link { "MyString" }
    startdate { "2018-04-27 19:48:51" }
    enddate { "2018-04-27 19:48:51" }
    lat { "MyString" }
    lon { "MyString" }
    location { "MyString" }
    address { "MyString" }
    zip { "MyString" }
    city { "MyString" }
    country { "MyString" }
    published { false }
    layer
    trait :invalid do
      title { nil }
    end
    trait :changed do
      title { "OtherTitle" }
    end
    trait :changed_and_published do
      title { "OtherTitle" }
      published { true }
    end
  end
end
