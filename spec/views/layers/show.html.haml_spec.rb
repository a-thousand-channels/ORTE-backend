require 'rails_helper'

RSpec.describe 'layers/show', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user

    @map = FactoryBot.create(:map, group_id: group.id)
    @layer = FactoryBot.create(:layer, map_id: @map.id)
    @maps =  FactoryBot.create_list(:map, 3)
    @map_layers = @map.layers
    @layer = assign(:layer,
      Layer.create!(
        title: 'Title',
        text: 'Text',
        published: false,
        map: @map
      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
  end
end
