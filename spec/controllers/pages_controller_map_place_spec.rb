# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  render_views

  let(:group) { FactoryBot.create(:group) }
  let(:user) { FactoryBot.create(:admin_user, group_id: group.id) }
  let(:map) { FactoryBot.create(:map, group_id: group.id) }
  let(:place) { FactoryBot.create(:place) }
  let(:valid_session) { {} }
  let(:page_attrs) { FactoryBot.attributes_for(:page) }
  let(:invalid_attrs) { FactoryBot.attributes_for(:page, :invalid) }

  before do
    I18n.locale = I18n.default_locale
    sign_in user
  end

  describe 'Map context' do
    describe 'GET #index' do
      it 'returns a success response' do
        FactoryBot.create(:page, pageable: map)
        get :index, params: { locale: I18n.default_locale, map_id: map.id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:pageable)).to eq(map)
        expect(assigns(:pages)).to eq(map.pages)
      end
    end

    describe 'GET #new' do
      it 'returns a success response with @pageable set to map' do
        get :new, params: { locale: I18n.default_locale, map_id: map.id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:pageable)).to eq(map)
        expect(assigns(:page)).to be_a_new(Page)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new page with map as pageable' do
          expect do
            post :create, params: {
              locale: I18n.default_locale,
              map_id: map.id,
              page: page_attrs.merge(title: 'Map Page')
            }, session: valid_session
          end.to change(Page, :count).by(1)

          page = Page.last
          expect(page.pageable).to eq(map)
          expect(page.pageable_type).to eq('Map')
          expect(page.title).to eq('Map Page')
        end

        it 'redirects to the created page using polymorphic path' do
          post :create, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            page: page_attrs
          }, session: valid_session

          page = Page.last
          expect(response).to redirect_to(map_page_path(map, page, locale: I18n.default_locale))
        end
      end

      context 'with invalid params' do
        it 'returns a success response and renders new' do
          post :create, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            page: invalid_attrs
          }, session: valid_session

          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'GET #edit' do
      let(:page) { FactoryBot.create(:page, pageable: map) }

      it 'returns a success response' do
        get :edit, params: {
          locale: I18n.default_locale,
          map_id: map.id,
          id: page.id
        }, session: valid_session

        expect(response).to have_http_status(200)
        expect(assigns(:page)).to eq(page)
      end
    end

    describe 'PATCH/PUT #update' do
      let(:page) { FactoryBot.create(:page, pageable: map, title: 'Old Title') }

      context 'with valid params' do
        it 'updates the requested page' do
          patch :update, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            id: page.id,
            page: page_attrs.merge(title: 'Updated Title')
          }, session: valid_session

          page.reload
          expect(page.title).to eq('Updated Title')
        end

        it 'redirects to the page using polymorphic path' do
          patch :update, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            id: page.id,
            page: page_attrs
          }, session: valid_session

          expect(response).to redirect_to(map_page_path(map, page, locale: I18n.default_locale))
        end
      end

      context 'with invalid params' do
        it 'returns a success response and renders edit' do
          patch :update, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            id: page.id,
            page: invalid_attrs
          }, session: valid_session

          expect(response).to have_http_status(200)
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:page) { FactoryBot.create(:page, pageable: map) }

      it 'destroys the requested page' do
        # Pre-create the page before the expect block
        test_page = page
        expect do
          delete :destroy, params: {
            locale: I18n.default_locale,
            map_id: map.id,
            id: test_page.id
          }, session: valid_session
        end.to change(Page, :count).by(-1)
      end

      it 'redirects to the map using polymorphic path' do
        delete :destroy, params: {
          locale: I18n.default_locale,
          map_id: map.id,
          id: page.id
        }, session: valid_session

        expect(response).to redirect_to(map_path(map, locale: I18n.default_locale))
      end
    end
  end

  describe 'Place context' do
    describe 'GET #index' do
      it 'returns a success response' do
        FactoryBot.create(:page, pageable: place)
        get :index, params: { locale: I18n.default_locale, place_id: place.id, layer_id: place.layer.id, map_id: place.layer.map.id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:pageable)).to eq(place)
        expect(assigns(:pages)).to eq(place.pages)
      end
    end

    describe 'GET #new' do
      it 'returns a success response with @pageable set to place' do
        get :new, params: { locale: I18n.default_locale, place_id: place.id, layer_id: place.layer.id, map_id: place.layer.map.id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:pageable)).to eq(place)
        expect(assigns(:page)).to be_a_new(Page)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new page with place as pageable' do
          expect do
            post :create, params: {
              locale: I18n.default_locale,
              place_id: place.id,
              layer_id: place.layer.id,
              map_id: place.layer.map.id,
              page: page_attrs.merge(title: 'Place Page')
            }, session: valid_session
          end.to change(Page, :count).by(1)

          page = Page.last
          expect(page.pageable).to eq(place)
          expect(page.pageable_type).to eq('Place')
          expect(page.title).to eq('Place Page')
        end

        it 'redirects to the created page using polymorphic path' do
          post :create, params: {
            locale: I18n.default_locale,
            place_id: place.id,
            layer_id: place.layer.id,
            map_id: place.layer.map.id,
            page: page_attrs
          }, session: valid_session

          page = Page.last
          expect(response).to redirect_to(map_layer_place_page_path(place.layer.map, place.layer, place, page, locale: I18n.default_locale))
        end
      end
    end

    describe 'GET #edit' do
      let(:page) { FactoryBot.create(:page, pageable: place) }

      it 'returns a success response' do
        get :edit, params: {
          locale: I18n.default_locale,
          map_id: place.layer.map.id,
          layer_id: place.layer.id,
          place_id: place.id,
          id: page.id
        }, session: valid_session

        expect(response).to have_http_status(200)
        expect(assigns(:page)).to eq(page)
      end
    end

    describe 'PATCH/PUT #update' do
      let(:page) { FactoryBot.create(:page, pageable: place, title: 'Old Title') }

      it 'updates the requested page and redirects using polymorphic path' do
        patch :update, params: {
          locale: I18n.default_locale,
          map_id: place.layer.map.id,
          layer_id: place.layer.id,
          place_id: place.id,
          id: page.id,
          page: page_attrs.merge(title: 'Updated Title')
        }, session: valid_session

        page.reload
        expect(page.title).to eq('Updated Title')
        expect(response).to redirect_to(map_layer_place_page_path(place.layer.map, place.layer, place, page, locale: I18n.default_locale))
      end
    end

    describe 'DELETE #destroy' do
      let(:page) { FactoryBot.create(:page, pageable: place) }

      it 'destroys the requested page' do
        # Pre-create the page before the expect block
        test_page = page
        expect do
          delete :destroy, params: {
            locale: I18n.default_locale,
            map_id: place.layer.map.id,
            layer_id: place.layer.id,
            place_id: place.id,
            id: test_page.id
          }, session: valid_session
        end.to change(Page, :count).by(-1)
      end

      it 'redirects to the place using polymorphic path' do
        delete :destroy, params: {
          locale: I18n.default_locale,
          map_id: place.layer.map.id,
          layer_id: place.layer.id,
          place_id: place.id,
          id: page.id
        }, session: valid_session

        expect(response).to redirect_to(map_layer_place_path(place.layer.map, place.layer, place, locale: I18n.default_locale))
      end
    end
  end
end
