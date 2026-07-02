# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/edit', type: :view do
  describe 'Map context' do
    before(:each) do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
      @page = assign(:page, FactoryBot.create(:page, pageable: @map))
      assign(:pageable, @map)
      assign(:locale, I18n.default_locale)
    end

    it 'renders edit page form for map' do
      render
      assert_select 'form' do
        assert_select 'input[name=?]', 'page[title]'
      end
    end

    it 'displays map link in edit form' do
      render
      expect(rendered).to match(/#{@map.title}/)
    end

    it 'has pageable_id and pageable_type hidden fields' do
      render
      assert_select 'input[name=?][value=?]', 'page[pageable_id]', @map.id.to_s
      assert_select 'input[name=?][value=?]', 'page[pageable_type]', 'Map'
    end
  end

  describe 'Place context' do
    before(:each) do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @place = FactoryBot.create(:place)
      @page = assign(:page, FactoryBot.create(:page, pageable: @place))
      assign(:pageable, @place)
      assign(:locale, I18n.default_locale)
    end

    it 'renders edit page form for place' do
      render
      assert_select 'form' do
        assert_select 'input[name=?]', 'page[title]'
      end
    end

    it 'displays place link in edit form' do
      render
      expect(rendered).to match(/#{@place.title}/)
    end

    it 'has pageable_id and pageable_type hidden fields' do
      render
      assert_select 'input[name=?][value=?]', 'page[pageable_id]', @place.id.to_s
      assert_select 'input[name=?][value=?]', 'page[pageable_type]', 'Place'
    end
  end
end
