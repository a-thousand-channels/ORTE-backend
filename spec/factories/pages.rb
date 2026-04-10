FactoryBot.define do
  factory :page do
    title { "MyString" }
    subtitle { "MyString" }
    teaser { "MyText" }
    text { "MyText" }
    published { false }
    state { "MyString" }
    map { nil }
  end
end
