require 'rails_helper'

RSpec.describe "images/show", type: :view do
  before(:each) do
    @image = assign(:image, Image.create!(
      title: "Title",
      licence: "Licence",
      source: "MyText",
      creator: "Creator",
      place: nil,
      alt: "Alt",
      caption: "Caption",
      sorting: 2,
      preview: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Licence/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Creator/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Alt/)
    expect(rendered).to match(/Caption/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
