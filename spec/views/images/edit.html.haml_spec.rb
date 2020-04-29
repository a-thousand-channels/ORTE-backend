require 'rails_helper'

RSpec.describe "images/edit", type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, :map_id=> @map.id)
    @place = FactoryBot.create(:place, :layer_id => @layer.id)
    @image = FactoryBot.create(:image, :place_id => @place.id)
  end

  it "renders the edit image form" do
    render

    assert_select "form[action=?][method=?]", map_layer_place_image_path(@map,@layer,@place,@image), "post" do

      assert_select "input[name=?]", "image[title]"

      assert_select "input[name=?]", "image[licence]"

      assert_select "textarea[name=?]", "image[source]"

      assert_select "input[name=?]", "image[creator]"

      assert_select "input[name=?]", "image[alt]"

      assert_select "input[name=?]", "image[caption]"

      assert_select "input[name=?]", "image[sorting]"

      assert_select "input[name=?]", "image[preview]"
    end
  end
end
