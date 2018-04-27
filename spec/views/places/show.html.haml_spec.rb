require 'rails_helper'

RSpec.describe "places/show", type: :view do
  before(:each) do
    @place = assign(:place, Place.create!(
      :title => "Title",
      :teaser => "MyText",
      :text => "MyText",
      :link => "Link",
      :lat => "Lat",
      :lon => "Lon",
      :location => "Location",
      :address => "Address",
      :zip => "Zip",
      :city => "City",
      :country => "Country",
      :published => false,
      :layer => nil
    ))
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
