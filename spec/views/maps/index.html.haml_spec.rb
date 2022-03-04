# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'maps/index', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:user, group: group)
    sign_in user

    assign(:maps, [
             Map.create!(
               title: 'Title1',
               text: 'Text',
               published: false,
               group: group
             ),
             Map.create!(
               title: 'Title2',
               text: 'Text',
               published: false,
               group: group
             )
           ])
  end

  it 'renders a list of maps' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
