FactoryBot.define do
  factory :image do
    title { "MyString" }
    licence { "MyString" }
    source { "MyText" }
    creator { "MyString" }
    place { nil }
    alt { "MyString" }
    caption { "MyString" }
    sorting { 1 }
    preview { false }
  end
end
