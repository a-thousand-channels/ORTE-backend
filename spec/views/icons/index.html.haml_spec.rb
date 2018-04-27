require 'rails_helper'

RSpec.describe "icons/index", type: :view do
  before(:each) do
    assign(:icons, [
      Icon.create!(
        :title => "Title",
        :image => "Image",
        :iconset => nil
      ),
      Icon.create!(
        :title => "Title",
        :image => "Image",
        :iconset => nil
      )
    ])
  end

  it "renders a list of icons" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Image".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
