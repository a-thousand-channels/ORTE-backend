require 'rails_helper'

RSpec.describe "places/index", type: :view do
  before(:each) do
    assign(:places, [
      Place.create!(
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
      ),
      Place.create!(
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
      )
    ])
  end

  it "renders a list of places" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    assert_select "tr>td", :text => "Lat".to_s, :count => 2
    assert_select "tr>td", :text => "Lon".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
