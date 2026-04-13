# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/edit', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id, enable_privacy_features: false)
    @page = assign(:page, Page.create!(
                            title: 'MyString',
                            text: 'MyString',
                            published: false,
                            map: @map
                          ))
    @colors_selectable = %w[aaa bbb ccc]
  end

  it 'renders the edit page form' do
    render

    assert_select 'form[action=?][method=?]', map_page_path(@page.friendly_id, map_id: @map.friendly_id), 'post' do
      assert_select 'input[name=?]', 'page[title]'
      assert_select 'input[name=?]', 'page[subtitle]'
      assert_select 'textarea[name=?]', 'page[text]'
    end
  end
end
