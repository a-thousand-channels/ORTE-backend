require 'rails_helper'

RSpec.describe "images/show", type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, :map_id=> @map.id)
    @place = FactoryBot.create(:place, :layer_id => @layer.id)
    @image = FactoryBot.create(:image, :place_id => @place.id)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Licence/)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/Creator/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Alt/)
    expect(rendered).to match(/Caption/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
