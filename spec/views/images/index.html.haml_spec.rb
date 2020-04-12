require 'rails_helper'

RSpec.describe "images/index", type: :view do
  before(:each) do
    assign(:images, [
      Image.create!(
        title: "Title",
        licence: "Licence",
        source: "MyText",
        creator: "Creator",
        place: nil,
        alt: "Alt",
        caption: "Caption",
        sorting: 2,
        preview: false
      ),
      Image.create!(
        title: "Title",
        licence: "Licence",
        source: "MyText",
        creator: "Creator",
        place: nil,
        alt: "Alt",
        caption: "Caption",
        sorting: 2,
        preview: false
      )
    ])
  end

  it "renders a list of images" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "Licence".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Creator".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Alt".to_s, count: 2
    assert_select "tr>td", text: "Caption".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
