# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/groups/edit', type: :view do
  before(:each) do
    @admin_group = assign(:group, Group.create!(
                                    title: 'MyString'
                                  ))
    user = FactoryBot.create(:admin_user, group_id: @admin_group.id)
  end

  it 'renders the edit group form' do
    render

    assert_select 'form[action=?][method=?]', admin_group_path(@admin_group), 'post' do
      assert_select 'input[name=?]', 'admin_group[title]'
    end
  end
end
