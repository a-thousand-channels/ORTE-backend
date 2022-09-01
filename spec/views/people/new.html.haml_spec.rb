# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/new', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    assign(:person, Person.new(
                      name: 'MyString',
                      info: 'MyText',
                      map: @map
                    ))
  end

  it 'renders new person form' do
    render

    assert_select 'form[action=?][method=?]', map_people_path(@map), 'post' do
      assert_select 'input[name=?]', 'person[name]'

      assert_select 'textarea[name=?]', 'person[info]'
    end
  end
end
