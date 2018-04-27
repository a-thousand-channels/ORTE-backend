require 'rails_helper'

RSpec.describe "layers/edit", type: :view do
  before(:each) do
    @layer = assign(:layer, Layer.create!(
      :title => "MyString",
      :text => "MyString",
      :published => false,
      :map => nil
    ))
  end

  it "renders the edit layer form" do
    render

    assert_select "form[action=?][method=?]", layer_path(@layer), "post" do

      assert_select "input[name=?]", "layer[title]"

      assert_select "input[name=?]", "layer[text]"

      assert_select "input[name=?]", "layer[published]"

      assert_select "input[name=?]", "layer[map_id]"
    end
  end
end
