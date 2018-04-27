require 'rails_helper'

RSpec.describe "iconsets/new", type: :view do
  before(:each) do
    assign(:iconset, Iconset.new(
      :title => "MyString",
      :text => "MyText",
      :image => "MyString"
    ))
  end

  it "renders new iconset form" do
    render

    assert_select "form[action=?][method=?]", iconsets_path, "post" do

      assert_select "input[name=?]", "iconset[title]"

      assert_select "textarea[name=?]", "iconset[text]"

      assert_select "input[name=?]", "iconset[image]"
    end
  end
end
