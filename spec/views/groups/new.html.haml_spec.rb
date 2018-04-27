require 'rails_helper'

RSpec.describe "groups/new", type: :view do
  before(:each) do
    assign(:group, Group.new(
      :title => "MyString",
      :user => nil
    ))
  end

  it "renders new group form" do
    render

    assert_select "form[action=?][method=?]", groups_path, "post" do

      assert_select "input[name=?]", "group[title]"

      assert_select "input[name=?]", "group[user_id]"
    end
  end
end
