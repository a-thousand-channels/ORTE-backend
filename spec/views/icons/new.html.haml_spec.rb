require 'rails_helper'

RSpec.describe "icons/new", type: :view do
  before(:each) do
    assign(:icon, Icon.new(
      :title => "MyString",
      :image => "MyString",
      :iconset => nil
    ))
  end

  it "renders new icon form" do
    render

    assert_select "form[action=?][method=?]", icons_path, "post" do

      assert_select "input[name=?]", "icon[title]"

      assert_select "input[name=?]", "icon[image]"

      assert_select "input[name=?]", "icon[iconset_id]"
    end
  end
end
