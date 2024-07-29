# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/index', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    assign(:people, [
             Person.create!(
               name: 'Name1',
               info: 'MyText1',
               map: @map
             ),
             Person.create!(
               name: 'Name2',
               info: 'MyText2',
               map: @map
             )
           ])
  end

  it 'renders a list of people' do
    render
    expect(rendered).to match(/Name1/)
    expect(rendered).to match(/Name2/)
    expect(rendered).to match(/MyText1/)
  end
end
