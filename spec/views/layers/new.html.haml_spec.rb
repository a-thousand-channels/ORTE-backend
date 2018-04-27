require 'rails_helper'

RSpec.describe "layers/new", type: :view do
  before(:each) do
    assign(:layer, Layer.new(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :map => nil
    ))
  end

  it "renders new layer form" do
    render

    assert_select "form[action=?][method=?]", layers_path, "post" do

      assert_select "input[name=?]", "layer[title]"

      assert_select "input[name=?]", "layer[text]"

      assert_select "input[name=?]", "layer[published]"

      assert_select "input[name=?]", "layer[map_id]"
    end
  end
end
