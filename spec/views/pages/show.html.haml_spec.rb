# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/show', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user

    @map = FactoryBot.create(:map, group_id: group.id)
    @page = FactoryBot.create(:page, map_id: @map.id)
    @maps =  FactoryBot.create_list(:map, 3)
    @map_pages = @map.pages
    @page = assign(:page,
                    Page.create!(
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
