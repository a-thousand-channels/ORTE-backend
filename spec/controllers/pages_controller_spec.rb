# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  # needed for json builder test, since json builder files are handled as views:
  render_views

  describe "functionalities with logged in user with role 'admin'" do
    before do
      I18n.locale = I18n.default_locale
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
    end

    let(:page) do
      FactoryBot.create(:page, map_id: @map.id)
    end

    let(:valid_attributes) do
      FactoryBot.attributes_for(:page, map_id: @map.id)
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:page, :invalid, map_id: @map.id)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :index, params: { locale: I18n.default_locale, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #images' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :images, params: { locale: I18n.default_locale, map_id: @map.id, id: page.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #search' do
      it 'returns a success response' do
        Page.create! valid_attributes
        get :search, params: { locale: I18n.default_locale, map_id: @map.id, q: { query: 'Nope' } }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response' do
        Page.create! valid_attributes
        FactoryBot.create(:page, title: 'Test')
        get :search, params: { locale: I18n.default_locale, map_id: @map.id, q: { query: 'Test' } }, session: valid_session
        expect(assigns(:pages)).to eq([page])
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :show, params: { locale: I18n.default_locale, map_id: @map.friendly_id, id: page.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'returns a redirect to an friendly_id' do
        page = Page.create! valid_attributes
        get :show, params: { locale: I18n.default_locale, map_id: @map.friendly_id, id: page.id }, session: valid_session
        expect(response).to have_http_status(301)
      end
      it 'returns a no success response (for a non-accesible map)' do
        another_group = FactoryBot.create(:group)
        map = FactoryBot.create(:map, group_id: another_group.id)
        page = FactoryBot.create(:page, map_id: map.id)
        get :show, params: { locale: I18n.default_locale, map_id: map.friendly_id, id: page.friendly_id }, session: valid_session
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to match 'Sorry, this map could not be found.'
      end
    end

    describe 'GET #show as json' do
      it 'returns a success reponse' do
        page = Page.create! valid_attributes
        get :show, params: { locale: I18n.default_locale, id: page.friendly_id, map_id: @map.friendly_id }, session: valid_session, format: 'json'
        expect(response).to have_http_status(200)
      end

      it 'a page w/title for a published page' do
        page = FactoryBot.create(:page, map_id: @map.id, published: true)
        get :show, params: { locale: I18n.default_locale, id: page.friendly_id, map_id: @map.friendly_id }, session: valid_session, format: 'json'
        json = JSON.parse(response.body)
        expect(json['title']).to eq page.title
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { locale: I18n.default_locale, map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :edit, params: { locale: I18n.default_locale, map_id: @map.friendly_id, id: page.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Page' do
          expect do
            post :create, params: { locale: I18n.default_locale, map_id: @map.friendly_id, page: valid_attributes }, session: valid_session
          end.to change(Page, :count).by(1)
        end

        it 'redirects to the map' do
          post :create, params: { locale: I18n.default_locale, map_id: @map.friendly_id, page: valid_attributes }, session: valid_session
          page = Page.last
          expect(response).to redirect_to(map_page_path(@map.friendly_id, page))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { locale: I18n.default_locale, map_id: @map.id, page: invalid_attributes }, session: valid_session
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'PUT #update' do
      let(:image_page) do
        FactoryBot.create(:page, :with_images, map_id: @map.id)
      end

      let(:images_files) do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg')
        ]
      end

      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.build(:page, :changed, map_id: @map.id).attributes
        end

        it 'updates the requested page' do
          page = Page.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, map_id: @map.id, id: page.id, page: new_attributes }, session: valid_session
          page.reload
          expect(page.title).to eq('OtherTitle')
          expect(page.image_alt).to eq(new_attributes['image_alt'])
        end

        it 'redirects to the page' do
          page = Page.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, map_id: @map.id, id: page.id, page: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_page_path(@map.friendly_id, page))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          page = Page.create! valid_attributes
          put :update, params: { locale: I18n.default_locale, map_id: @map.id, id: page.friendly_id, page: invalid_attributes }, session: valid_session
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested page' do
        page = Page.create! valid_attributes
        expect do
          delete :destroy, params: { locale: I18n.default_locale, map_id: @map.id, id: page.friendly_id }, session: valid_session
        end.to change(Page, :count).by(-1)
      end

      it 'redirects to the pages list' do
        page = Page.create! valid_attributes
        delete :destroy, params: { locale: I18n.default_locale, map_id: @map.id, id: page.friendly_id }, session: valid_session
        expect(response).to redirect_to(map_url(@map))
      end
    end

    describe '#validate_images_format' do
      let(:images_files) do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg')
        ]
      end
      let(:falsey_images_files) do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg')
        ]
      end
      let(:no_images_files) do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test.txt'), 'text/plain'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test.txt'), 'text/plain')
        ]
      end

      let(:page) do
        FactoryBot.create(:page, :with_images, map_id: @map.id)
      end

      let(:valid_image_page_attributes) do
        page.attributes
      end

      context 'with valid image files' do
        before do
          valid_image_page_attributes.merge!(images_files: images_files)
        end

        it 'returns true' do
          controller.params[:page] = valid_image_page_attributes
          expect(controller.send(:validate_images_format)).to be_truthy
        end
      end

      context 'with invalid image files' do
        before do
          valid_image_page_attributes.merge!(images_files: no_images_files)
        end

        it 'adds an error to the page' do
          controller.params[:page] = valid_image_page_attributes
          expect(controller.send(:validate_images_format)).to be_falsey
          expect(flash[:alert]).to match 'Invalid file formats found. Only JPEG, PNG and GIF are allowed.'
        end
      end
    end
  end
end
