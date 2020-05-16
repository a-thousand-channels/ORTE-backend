# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'places/new', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map_id: @map.id)

    assign(:place, Place.new(
                     title: 'MyString',
                     teaser: 'MyText',
                     text: 'MyText',
                     link: 'MyString',
                     lat: 'MyString',
                     lon: 'MyString',
                     location: 'MyString',
                     address: 'MyString',
                     zip: 'MyString',
                     city: 'MyString',
                     country: 'MyString',
                     published: false,
                     layer: @layer
                   ))
  end

  it 'renders new place form' do
    render

    assert_select 'form[action=?][method=?]', map_layer_places_path(@layer, @map), 'post' do
      assert_select 'input[name=?]', 'place[title]'

      assert_select 'textarea[name=?]', 'place[teaser]'

      assert_select 'input[name=?]', 'place[link]'

      assert_select 'input[name=?]', 'place[lat]'

      assert_select 'input[name=?]', 'place[lon]'

      assert_select 'input[name=?]', 'place[location]'

      assert_select 'input[name=?]', 'place[address]'

      assert_select 'input[name=?]', 'place[zip]'

      assert_select 'input[name=?]', 'place[city]'
    end
  end
end
