# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/new', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    @map = FactoryBot.create(:map, group_id: group.id)
    assign(:page, Page.new(
                    title: 'MyString',
                    text: 'MyString',
                    published: false,
                    map: @map
                  ))
  end

  it 'renders new page form' do
    render

    assert_select 'form[action=?][method=?]', map_pages_path(locale: I18n.default_locale, map_id: @map.friendly_id), 'post' do
      assert_select 'input[name=?]', 'page[title]'
    end
  end
end
