require 'rails_helper'

RSpec.describe "images/new", type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, :map_id=> @map.id)
    @place = FactoryBot.create(:place, :layer_id => @layer.id)
    @image = FactoryBot.create(:image, :place_id => @place.id)

    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, :group_id => group.id)
    sign_in user
    assign(:image, Image.new(
      :title => "MyString",
      :place => @place    
    ))    
  end

  it "renders new image form" do
    render

    assert_select "form[action=?][method=?]", images_path, "post" do

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
