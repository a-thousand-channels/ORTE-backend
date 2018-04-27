require 'rails_helper'

RSpec.describe "maps/new", type: :view do
  before(:each) do
    assign(:map, Map.new(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :group => nil
    ))
  end

  it "renders new map form" do
    render

    assert_select "form[action=?][method=?]", maps_path, "post" do

      assert_select "input[name=?]", "map[title]"

      assert_select "input[name=?]", "map[text]"

      assert_select "input[name=?]", "map[published]"

      assert_select "input[name=?]", "map[group_id]"
    end
  end
end
