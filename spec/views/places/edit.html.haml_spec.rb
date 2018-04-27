require 'rails_helper'

RSpec.describe "places/edit", type: :view do
  before(:each) do
    @place = assign(:place, Place.create!(
      :title => "MyString",
      :teaser => "MyText",
      :text => "MyText",
      :link => "MyString",
      :lat => "MyString",
      :lon => "MyString",
      :location => "MyString",
      :address => "MyString",
      :zip => "MyString",
      :city => "MyString",
      :country => "MyString",
      :published => false,
      :layer => nil
    ))
  end

  it "renders the edit place form" do
    render

    assert_select "form[action=?][method=?]", place_path(@place), "post" do

      assert_select "input[name=?]", "place[title]"

      assert_select "textarea[name=?]", "place[teaser]"

      assert_select "textarea[name=?]", "place[text]"

      assert_select "input[name=?]", "place[link]"

      assert_select "input[name=?]", "place[lat]"

      assert_select "input[name=?]", "place[lon]"

      assert_select "input[name=?]", "place[location]"

      assert_select "input[name=?]", "place[address]"

      assert_select "input[name=?]", "place[zip]"

      assert_select "input[name=?]", "place[city]"

      assert_select "input[name=?]", "place[country]"

      assert_select "input[name=?]", "place[published]"

      assert_select "input[name=?]", "place[layer_id]"
    end
  end
end
