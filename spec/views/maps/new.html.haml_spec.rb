require 'rails_helper'

RSpec.describe "maps/new", type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, :group_id => group.id)
    sign_in user
    assign(:map, Map.new(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :group => group
    ))
  end

  it "renders new map form" do
    render

    assert_select "form[action=?][method=?]", maps_path, "post" do

      assert_select "input[name=?]", "map[title]"

      assert_select "input[name=?]", "map[text]"

    end
  end
end
