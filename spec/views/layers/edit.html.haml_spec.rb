# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layers/edit', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id, enable_privacy_features: false)
    @layer = assign(:layer, Layer.create!(
                              title: 'MyString',
                              text: 'MyString',
                              published: false,
                              map: @map
                            ))
    @colors_selectable = %w[aaa bbb ccc]
  end

  it 'renders the edit layer form' do
    render

    assert_select 'form[action=?][method=?]', map_layer_path(@layer.friendly_id, map_id: @map.friendly_id), 'post' do
      assert_select 'input[name=?]', 'layer[title]'
      assert_select 'input[name=?]', 'layer[subtitle]'
      assert_select 'textarea[name=?]', 'layer[text]'
    end
  end

  it 'renders the edit layer form without privacy features' do
    render

    assert_select 'form[action=?][method=?]', map_layer_path(@layer.friendly_id, map_id: @map.friendly_id), 'post' do
      assert_select 'input[name=?]', 'layer[layer_exif_remove]', false
      assert_select 'input[name=?]', 'layer[layer_rasterize_images]', false
    end
  end
end
