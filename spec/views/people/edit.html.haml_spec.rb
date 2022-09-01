# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/edit', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    @person = assign(:person, Person.create!(
                                name: 'MyString',
                                info: 'MyText',
                                map: @map
                              ))
  end

  it 'renders the edit person form' do
    render

    assert_select 'form[action=?][method=?]', map_person_path(@map, @person), 'post' do
      assert_select 'input[name=?]', 'person[name]'

      assert_select 'textarea[name=?]', 'person[info]'
    end
  end
end
