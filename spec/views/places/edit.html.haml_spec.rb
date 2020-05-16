# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'places/edit', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map_id: @map.id)
    @place = FactoryBot.create(:place, layer_id: @layer.id)
  end

  it 'renders the edit place form' do
    render

    assert_select 'form[action=?][method=?]', map_layer_place_path(@place, @layer, @map), 'post' do
      assert_select 'input[name=?]', 'place[title]'

      assert_select 'textarea[name=?]', 'place[teaser]'

      assert_select 'input[name=?]', 'place[link]'

      assert_select 'input[name=?]', 'place[lat]'

      assert_select 'input[name=?]', 'place[lon]'

      assert_select 'input[name=?]', 'place[location]'

      assert_select 'input[name=?]', 'place[address]'

      assert_select 'input[name=?]', 'place[zip]'

      assert_select 'input[name=?]', 'place[city]'

      assert_select 'input[name=?]', 'place[published]'
    end
  end
end
