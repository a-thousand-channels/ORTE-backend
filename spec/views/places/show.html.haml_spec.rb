require 'rails_helper'

RSpec.describe "places/show", type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, :map_id=> @map.id)
    @place = FactoryBot.create(:place, :layer_id => @layer.id)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Link/)
    expect(rendered).to match(/Lat/)
    expect(rendered).to match(/Lon/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Zip/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
