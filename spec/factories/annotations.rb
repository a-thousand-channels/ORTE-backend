FactoryBot.define do
  factory :annotation do
    title { "MyString" }
    text { "MyText" }
    published { "" }
    sorting { 1 }
    source { "MyText" }
    place
  end
end
