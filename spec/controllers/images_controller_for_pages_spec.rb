# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: @group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: @group.id)
      @page = FactoryBot.create(:page, map_id: @map.id)
    end

    let(:image) do
      FactoryBot.create(:image, :with_file, imageable_type: 'Page', imageable_id: @page.id)
    end

    let(:valid_attributes) do
      FactoryBot.attributes_for(:image, :with_file, imageable_type: 'Page', imageable_id: @page.id)
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:image, :invalid)
    end

    let(:without_file_attributes) do
      FactoryBot.attributes_for(:image, :without_file, imageable_type: 'Page', imageable_id: @page.id)
    end

    let(:with_wrong_fileformat_attributes) do
      FactoryBot.attributes_for(:image, :with_wrong_fileformat, imageable_type: 'Page', imageable_id: @page.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: { locale: I18n.default_locale, map_id: @map.id, page_id: @page.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'redirects to root_url' do
        @another_group = FactoryBot.create(:group)
        @another_map = FactoryBot.create(:map, group_id: @another_group.id)
        @another_layer = FactoryBot.create(:layer, map_id: @another_map.id, title: 'Another layer title')
        @another_page = FactoryBot.create(:page, map_id: @another_map.id)
        get :index, params: { locale: I18n.default_locale, map_id: @another_map.id, page_id: @another_page.id }, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        image = Image.create! valid_attributes
        get :show, params: { locale: I18n.default_locale, id: image.to_param, page_id: @page.id, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'redirects to root_url (if not admin)' do
        @another_group = FactoryBot.create(:group)
        user = FactoryBot.create(:user, group_id: @another_group.id)
        sign_in user
        @another_map = FactoryBot.create(:map, group_id: @another_group.id)
        @another_page = FactoryBot.create(:page, map_id: @another_map.id)
        image = Image.create! valid_attributes
        get :show, params: { locale: I18n.default_locale, id: image.to_param, map_id: @another_map.id, page_id: @another_page.id }, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { locale: I18n.default_locale, page_id: @page.id, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        image = Image.create! valid_attributes
        get :edit, params: { locale: I18n.default_locale, id: image.to_param, page_id: @page.id, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Image' do
          expect do
            post :create, params: { locale: I18n.default_locale, image: valid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          end.to change(Image, :count).by(1)
        end

        it 'redirects to the created image' do
          post :create, params: { locale: I18n.default_locale, image: valid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to have_http_status(302)
        end

        it 'redirects to related page url', focus: true do
          post :create, params: { locale: I18n.default_locale, image: valid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to redirect_to(edit_map_page_url(locale: I18n.default_locale, map: @map, page: @page))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { locale: I18n.default_locale, image: invalid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
      context 'wit wrong fileformat' do
        it "returns a success response (i.e. to display the 'new' template)" do
          pending 'fails to prevent save with wrong fileformat'
          post :create, params: { locale: I18n.default_locale, image: with_wrong_fileformat_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
      context 'without file' do
        it "returns a success response (i.e. to display the 'new' template)" do
          pending 'fails to prevent save with missing file'
          post :create, params: { locale: I18n.default_locale, image: without_file_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to render_template('new')
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:image, :changed, imageable_type: 'Page', imageable_id: @page.id)
        end

        it 'updates the requested image' do
          image = Image.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, id: image.to_param, image: new_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          image.reload
          expect(image.title).to eq('OtherTitle')
        end

        it 'redirects to the page' do
          image = Image.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, id: image.to_param, image: valid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to redirect_to(edit_map_page_url(locale: I18n.default_locale, map: @map, page: @page))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          image = Image.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, id: image.to_param, image: invalid_attributes, page_id: @page.id, map_id: @map.id }, session: valid_session
          expect(response).to have_http_status(200)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested image' do
        image = Image.create! valid_attributes
        expect do
          delete :destroy, params: { locale: I18n.default_locale, id: image.to_param, page_id: @page.id, map_id: @map.id }, session: valid_session
        end.to change(Image, :count).by(-1)
      end

      it 'redirects to the page edit view' do
        image = Image.create! valid_attributes
        delete :destroy, params: { locale: I18n.default_locale, id: image.to_param, page_id: @page.id, map_id: @map.id }, session: valid_session
        expect(response).to redirect_to(edit_map_page_url(locale: I18n.default_locale, map: @map, page: @page))
      end
    end
  end
end
