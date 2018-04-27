require 'rails_helper'

RSpec.describe "icons/edit", type: :view do
  before(:each) do
    @icon = assign(:icon, Icon.create!(
      :title => "MyString",
      :image => "MyString",
      :iconset => nil
    ))
  end

  it "renders the edit icon form" do
    render

    assert_select "form[action=?][method=?]", icon_path(@icon), "post" do

      assert_select "input[name=?]", "icon[title]"

      assert_select "input[name=?]", "icon[image]"

      assert_select "input[name=?]", "icon[iconset_id]"
    end
  end
end
