require 'rails_helper'

RSpec.describe "maps/edit", type: :view do
  before(:each) do
    @map = assign(:map, Map.create!(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :group => nil
    ))
  end

  it "renders the edit map form" do
    render

    assert_select "form[action=?][method=?]", map_path(@map), "post" do

      assert_select "input[name=?]", "map[title]"

      assert_select "input[name=?]", "map[text]"

      assert_select "input[name=?]", "map[published]"

      assert_select "input[name=?]", "map[group_id]"
    end
  end
end
