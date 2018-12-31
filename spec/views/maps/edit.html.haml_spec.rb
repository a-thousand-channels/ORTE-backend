require 'rails_helper'

RSpec.describe "maps/edit", type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, :group_id => group.id)
    sign_in user
    @map = assign(:map, Map.create!(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :group => group
    ))
  end

  it "renders the edit map form" do
    render

    assert_select "form[action=?][method=?]", map_path(@map), "post" do

      assert_select "input[name=?]", "map[title]"

      assert_select "input[name=?]", "map[text]"


    end
  end
end
