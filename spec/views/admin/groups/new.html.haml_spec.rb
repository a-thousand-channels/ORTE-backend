# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/groups/new', type: :view do
  before(:each) do
    @admin_group = assign(:group, Group.new(
                                    title: 'MyString'
                                  ))
  end

  it 'renders new group form' do
    render

    assert_select 'form[action=?][method=?]', admin_groups_path, 'post' do
      assert_select 'input[name=?]', 'admin_group[title]'
    end
  end
end
