# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::PagesController, type: :controller do
  render_views

  describe 'GET #index' do
    let(:valid_session) { {} }

    it 'returns pages for a published map looked up by id' do
      map = create(:map, published: true)
      page = create(:page, map: map, published: true)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['pages'].map { |json_page| json_page['id'] }).to eq([page.id])
    end

    it 'returns pages for a published map looked up by slug' do
      map = create(:map, published: true, title: 'Visible public map')
      page = create(:page, map: map, published: true)

      get :index, params: { locale: I18n.default_locale, map_id: map.friendly_id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['pages'].map { |json_page| json_page['id'] }).to eq([page.id])
    end

    it 'returns only published pages for a published map' do
      map = create(:map, published: true)
      published_page = create(:page, map: map, published: true, title: 'Published page')
      unpublished_page = create(:page, map: map, published: false, title: 'Draft page')

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['pages'].size).to eq(1)
      expect(json['pages'].first['id']).to eq(published_page.id)
      expect(json['pages'].first['title']).to eq('Published page')
      expect(json['pages'].map { |page| page['id'] }).not_to include(unpublished_page.id)
    end

    it 'returns 403 when map is not published' do
      map = create(:map, published: false)
      create(:page, map: map, published: true)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(403)
      expect(JSON.parse(response.body)['error']).to match(/Map not accessible/)
    end

    it 'returns 403 when a published map has no published pages' do
      map = create(:map, published: true)
      create(:page, map: map, published: false)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(403)
      expect(JSON.parse(response.body)['error']).to match(/Page not accessible/)
    end

    it 'returns published pages ordered by created_at' do
      map = create(:map, published: true)
      older_page = create(:page, map: map, published: true, title: 'Older page')
      newer_page = create(:page, map: map, published: true, title: 'Newer page')

      older_page.update_column(:created_at, 2.days.ago)
      newer_page.update_column(:created_at, 1.day.ago)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['pages'].map { |page| page['id'] }).to eq([older_page.id, newer_page.id])
    end

    it 'returns translated page content for the requested locale' do
      map = create(:map, published: true)
      page = I18n.with_locale(:en) do
        create(:page, map: map, published: true,
                      title: 'English title', subtitle: 'English subtitle',
                      text: 'English text', footer: 'English footer')
      end
      I18n.with_locale(:de) do
        page.update!(title: 'Deutscher Titel', subtitle: 'Deutscher Untertitel',
                     text: 'Deutscher Text', footer: 'Deutsche Fusszeile')
      end

      get :index, params: { locale: 'en', map_id: map.id, format: 'json' }, session: valid_session
      en_json = JSON.parse(response.body)

      get :index, params: { locale: 'de', map_id: map.id, format: 'json' }, session: valid_session
      de_json = JSON.parse(response.body)

      expect(en_json['pages'].first).to include(
        'title' => 'English title',
        'subtitle' => 'English subtitle',
        'text' => 'English text',
        'footer' => 'English footer'
      )
      expect(de_json['pages'].first).to include(
        'title' => 'Deutscher Titel',
        'subtitle' => 'Deutscher Untertitel',
        'text' => 'Deutscher Text',
        'footer' => 'Deutsche Fusszeile'
      )
    end

    it 'includes page images in the JSON response' do
      map = create(:map, published: true)
      page = create(:page, map: map, published: true)
      image = create(:image, imageable: page)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      expect(json['pages'].size).to eq(1)
      expect(json['pages'].first['images']).to be_present
      expect(json['pages'].first['images'].map { |img| img['id'] }).to include(image.id)
      expect(json['pages'].first['images'].first).to include(
        'id' => image.id,
        'title' => image.title,
        'source' => image.source,
        'creator' => image.creator,
        'alt' => image.alt
      )
    end

    it 'sets CORS headers on the response' do
      map = create(:map, published: true)
      create(:page, map: map, published: true)

      get :index, params: { locale: I18n.default_locale, map_id: map.id, format: 'json' }, session: valid_session

      expect(response).to have_http_status(200)
      expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
      expect(response.headers['Access-Control-Allow-Methods']).to eq('GET')
      expect(response.headers['Access-Control-Request-Method']).to eq('*')
      expect(response.headers['Access-Control-Allow-Headers']).to eq('Origin, X-Requested-With, Content-Type, Accept, Authorization')
    end
  end
end
