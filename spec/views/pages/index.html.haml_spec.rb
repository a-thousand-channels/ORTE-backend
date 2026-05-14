# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/index', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    assign(:pages, [
             Page.create!(
               title: 'Title1',
               text: 'Text',
               published: false,
               map: @map
             ),
             Page.create!(
               title: 'Title2',
               text: 'Text',
               published: false,
               map: @map
             )
           ])
  end

  it 'renders a list of pages' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
