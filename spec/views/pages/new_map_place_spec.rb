# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/new', type: :view do
  describe 'Map context' do
    before(:each) do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @page = assign(:page, Page.new(pageable: @map))
      assign(:pageable, @map)
      assign(:locale, I18n.default_locale)
    end

    it 'renders new page form for map' do
      render
      assert_select 'form' do
        assert_select 'input[name=?]', 'page[title]'
        assert_select 'input[name=?][value=?]', 'page[pageable_type]', 'Map'
      end
    end

    it 'displays map title in form' do
      render
      expect(rendered).to match(/#{@map.title}/)
    end
  end

  describe 'Place context' do
    before(:each) do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @place = FactoryBot.create(:place)
      @page = assign(:page, Page.new(pageable: @place))
      assign(:pageable, @place)
      assign(:locale, I18n.default_locale)
    end

    it 'renders new page form for place' do
      render
      assert_select 'form' do
        assert_select 'input[name=?]', 'page[title]'
        assert_select 'input[name=?][value=?]', 'page[pageable_type]', 'Place'
      end
    end

    it 'displays place title in form' do
      render
      expect(rendered).to match(/#{@place.title}/)
    end
  end
end
