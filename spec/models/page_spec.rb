# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:page, title: nil)).not_to be_valid
  end

  describe 'translations' do
    it 'stores default and german title on the same page record' do
      page = nil

      I18n.with_locale(I18n.default_locale) do
        page = create(:page, title: 'English title')
      end

      I18n.with_locale(:de) do
        page.update!(title: 'Deutscher Titel')
      end

      expect(Page.where(id: page.id).count).to eq(1)

      I18n.with_locale(I18n.default_locale) do
        expect(Page.find(page.id).title).to eq('English title')
      end

      I18n.with_locale(:de) do
        expect(Page.find(page.id).title).to eq('Deutscher Titel')
      end

      expect(page.title_en).to eq('English title')
      expect(page.title_de).to eq('Deutscher Titel')
    end
  end
end
