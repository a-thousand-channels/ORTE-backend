# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'maps/show', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @maps = FactoryBot.create_list(:map, 3)
    @map = assign(:map, Map.create!(
                          title: 'Title',
                          text: 'Text',
                          published: false,
                          group: group
                        ))
    @layer = FactoryBot.create(:layer, map_id: @map.id)
    @map_layers = @map.layers
    @places = FactoryBot.create_list(:place, 3)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Create new layer/)
  end
end
