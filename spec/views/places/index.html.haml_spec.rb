# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'places/index', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map_id: @map.id)
    @places = assign(:places, [
                       Place.create!(
                         title: 'Title1',
                         teaser: 'MyText',
                         text: 'MyText',
                         link: 'Link',
                         lat: 'Lat',
                         lon: 'Lon',
                         location: 'Location',
                         address: 'Address',
                         zip: 'Zip',
                         city: 'City',
                         country: 'Country',
                         startdate: '2018-10-01',
                         published: false,
                         layer: @layer
                       ),
                       Place.create!(
                         title: 'Title2',
                         teaser: 'MyText',
                         text: 'MyText',
                         link: 'Link',
                         lat: 'Lat',
                         lon: 'Lon',
                         location: 'Location',
                         address: 'Address',
                         zip: 'Zip',
                         city: 'City',
                         country: 'Country',
                         startdate: '2018-10-02',
                         published: false,
                         layer: @layer
                       )
                     ])
  end

  xit 'renders a list of places' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
