require 'rails_helper'

RSpec.describe "maps/index", type: :view do
  before(:each) do
    assign(:maps, [
      Map.create!(
        :title => "Title",
        :text => "Text",
        :published => false,
        :group => nil
      ),
      Map.create!(
        :title => "Title",
        :text => "Text",
        :published => false,
        :group => nil
      )
    ])
  end

  it "renders a list of maps" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
