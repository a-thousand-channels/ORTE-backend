require 'rails_helper'

RSpec.describe "groups/edit", type: :view do
  before(:each) do
    @group = assign(:group, Group.create!(
      :title => "MyString",
      :user => nil
    ))
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(@group), "post" do

      assert_select "input[name=?]", "group[title]"

      assert_select "input[name=?]", "group[user_id]"
    end
  end
end
