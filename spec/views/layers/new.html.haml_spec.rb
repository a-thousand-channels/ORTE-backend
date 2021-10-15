# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layers/new', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    assign(:layer, Layer.new(
                     title: 'MyString',
                     text: 'MyString',
                     published: false,
                     map: @map
                   ))
  end

  it 'renders new layer form' do
    render

    assert_select 'form[action=?][method=?]', map_layers_path(@map.friendly_id), 'post' do
      assert_select 'input[name=?]', 'layer[title]'
    end
  end
end
