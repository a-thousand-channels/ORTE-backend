# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group: group)
      sign_in user
    end

    let(:page) do
      FactoryBot.create(:page)
    end

    let(:valid_attributes) do
      FactoryBot.build(:page).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:page, :invalid)
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: {}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        page = Page.create! valid_attributes
        get :edit, params: { id: page.to_param }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Page' do
          expect do
            post :create, params: { page: valid_attributes }, session: valid_session
          end.to change(Page, :count).by(1)
        end

        it 'redirects to the created page' do
          post :create, params: { page: valid_attributes }, session: valid_session
          expect(response).to redirect_to(page_url(@page))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { page: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:page, :changed)
        end

        it 'updates the requested page' do
          page = Page.create! valid_attributes
          put :update, params: { id: page.to_param, page: new_attributes }, session: valid_session
          page.reload
          expect(page.name).to eq('OtherName')
        end

        it 'redirects to the pageset' do
          page = Page.create! valid_attributes
          put :update, params: { id: page.to_param, page: valid_attributes }, session: valid_session
          expect(response).to redirect_to(page_url(@page))
        end
      end

      context 'with invalid params' do
        it 'returns an error response' do
          page = Page.create! valid_attributes
          expect do
            post :update, params: { id: page.to_param, page: invalid_attributes }
          end.to_not change(Page, :count)

          expect(response).to have_http_status(422)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested page' do
        page = Page.create! valid_attributes
        expect do
          delete :destroy, params: { id: page.to_param }, session: valid_session
        end.to change(Page, :count).by(-1)
      end

      it 'redirects to the pages list' do
        page = Page.create! valid_attributes
        delete :destroy, params: { id: page.to_param }, session: valid_session
        expect(response).to redirect_to(page_url(@page))
      end
    end
  end
end
