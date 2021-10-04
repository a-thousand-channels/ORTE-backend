# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::SubmissionsController, type: :controller do
  render_views

  describe 'functionalities with no login' do
    before do
      @map = FactoryBot.create(:map)
      @layer = FactoryBot.create(:layer, map: @map, public_submission: true)
      @place = FactoryBot.create(:place, layer: @layer)
    end

    let(:submission) do
      FactoryBot.create(:submission, place_id: @place.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:submission, place_id: @place.id).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.build(:submission, place_id: @place.id, name: false).attributes
    end

    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        get :index, params: { place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      xit 'returns a success response' do
        pending 'The session params are missing'
        submission = Submission.create! valid_attributes
        get :edit, params: { id: submission.to_param, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns redirect' do
        submission = Submission.create! valid_attributes
        @layer_with_no_public_submission = FactoryBot.create(:layer, map: @map, public_submission: false)

        get :edit, params: { id: submission.to_param, place_id: @place.id, layer_id: @layer_with_no_public_submission.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Submission' do
          expect do
            post :create, params: { submission: valid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          end.to change(Submission, :count).by(1)
        end

        it 'redirects to the related map' do
          post :create, params: { submission: valid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to redirect_to(submission_new_place_url(locale: 'de', submission_id: Submission.last, layer_id: @layer.id))
        end
      end

      context 'with invalid params' do
        xit "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { submission: invalid_attributes, map_id: @layer.map.id, place_id: @place.id, locale: 'de' }, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.build(:submission, :changed, place_id: @place.id).attributes
        end
        let(:new_attributes_with_published) do
          FactoryBot.build(:submission, :changed_and_published, place_id: @place.id).attributes
        end

        xit 'updates the requested submission' do
          submission = Submission.create! valid_attributes
          put :update, params: { id: submission.to_param, submission: new_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          submission.reload
          expect(submission.title_intro).to eq('OtherTitle')
        end

        xit 'redirects to the submission' do
          pending 'The state variable is missing'
          submission = Submission.create! valid_attributes
          put :update, params: { id: submission.to_param, submission: valid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to redirect_to(edit_map_layer_url(@layer.map, @layer))
        end
      end

      context 'with invalid params' do
        xit "returns a success response (i.e. to display the 'edit' template)" do
          pending 'The state variable is missing'
          submission = Submission.create! valid_attributes
          put :update, params: { id: submission.to_param, submission: invalid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end
  end
end
