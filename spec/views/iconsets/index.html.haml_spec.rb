require 'rails_helper'

RSpec.describe "iconsets/index", type: :view do
  before(:each) do
    assign(:iconsets, [
      Iconset.create!(
        :title => "Title",
        :text => "MyText",
        :image => "Image"
      ),
      Iconset.create!(
        :title => "Title",
        :text => "MyText",
        :image => "Image"
      )
    ])
  end

  it "renders a list of iconsets" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Image".to_s, :count => 2
  end
end
