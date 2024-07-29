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
      it 'returns a success response having a submission_config object' do
        @layer.submission_config = FactoryBot.create(:submission_config, layer_id: @layer, title_intro: 'submission_config_test')
        @layer.save!
        submission = Submission.create! valid_attributes
        get :index, params: { place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(@controller.instance_variable_get(:@submission_config).title_intro).to eq('submission_config_test')
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'redirects to submissions_path' do
        layer_submission_false = FactoryBot.create(:layer, map: @map, public_submission: false)
        get :new, params: { layer_id: layer_submission_false.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(submissions_path)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = submission.id
        get :edit, params: { id: submission.to_param, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns redirect because of wrong submission id' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = 20_001
        get :edit, params: { id: submission.to_param, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_submission_path)
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
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { submission: invalid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.attributes_for(:submission, name: 'OtherTitle')
        end

        it 'updates the requested submission' do
          submission = Submission.create! valid_attributes
          session[:submission_id] = submission.id
          put :update, params: { id: submission.to_param, submission: new_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          submission.reload
          expect(submission.name).to eq('OtherTitle')
        end

        it 'redirects to the submission place form' do
          submission = Submission.create! valid_attributes
          session[:submission_id] = submission.id
          put :update, params: { id: submission.to_param, submission: valid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to redirect_to(submission_edit_place_url(place_id: @place.id, submission_id: submission.id))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          submission = Submission.create! valid_attributes
          session[:submission_id] = submission.id
          put :update, params: { id: submission.to_param, submission: invalid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to have_http_status(302)
        end
        it 'returns redirect because of missing submission id' do
          submission = Submission.create! valid_attributes
          put :update, params: { id: submission.to_param, submission: invalid_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(new_submission_path)
        end
      end
    end

    describe 'GET #new_place' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = submission.id
        get :new_place, params: { layer_id: @layer.id, submission_id: submission.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create_place' do
      context 'with valid params' do
        it 'creates a new submission place' do
          submission = FactoryBot.create(:submission, place_id: @place.id, name: 'SubmissionName')
          session[:submission_id] = submission.id
          place_attributes = FactoryBot.attributes_for(:place, title: 'OtherTitle')
          expect do
            post :create_place, params: { place: place_attributes, layer_id: @layer.id, submission_id: submission.id, locale: 'de' }, session: valid_session
          end.to change(Place, :count).by(1)
          submission.reload
          expect(submission.place.title).to eq('SubmissionName')
        end
      end

      context 'with invalid params' do
        xit 'does not save the place and shows the form again' do
          pending('can not invalide the place creation...')
          submission = FactoryBot.create(:submission, name: 'SubmissionName')
          session[:submission_id] = submission.id
          invalide_place_attributes = FactoryBot.attributes_for(:place, title: nil, published: 'jein', country: nil)
          expect do
            post :create_place, params: { place: invalide_place_attributes, layer_id: @layer.id, submission_id: submission.id, locale: 'de' }, session: valid_session
          end.to change(Place, :count).by(1)

          expect(response).to have_http_status(302)
        end
      end
    end

    describe 'GET #edit_place' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = submission.id
        get :edit_place, params: { submission_id: submission.id, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'PUT #update_place' do
      context 'with valid params' do
        let(:new_place_attributes) do
          FactoryBot.attributes_for(:place, title: 'OtherTitle')
        end

        it 'updates the requested submission' do
          submission = Submission.create! valid_attributes
          session[:submission_id] = submission.id
          put :update_place, params: { submission_id: submission.to_param, place: new_place_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          submission.reload
          expect(submission.place.title).to eq('OtherTitle')
        end

        it 'redirects to the submission place form' do
          submission = Submission.create! valid_attributes
          session[:submission_id] = submission.id
          put :update_place, params: { submission_id: submission.to_param, place: new_place_attributes, place_id: @place.id, layer_id: @layer.id, locale: 'de' }, session: valid_session
          expect(response).to redirect_to(submission_new_image_url(place_id: @place.id, submission_id: submission.id))
        end
      end
    end

    describe 'GET #new_image' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = submission.id
        get :new_image, params: { layer_id: @layer.id, submission_id: submission.id, place_id: @place.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST #create_image' do
      context 'with valid params' do
        it 'creates a new submission image' do
          submission = FactoryBot.create(:submission, place_id: @place.id, status: 'SubmissionName')
          session[:submission_id] = submission.id
          image_attributes = FactoryBot.attributes_for(:image, :with_file)
          expect do
            post :create_image, params: { image: image_attributes, image_input: 1, layer_id: @layer.id, place_id: submission.place.id, submission_id: submission.id, locale: 'de' }, session: valid_session
          end.to change(Image, :count).by(1)
          expect(response).to redirect_to(submission_finished_url(layer_id: @layer.id, place_id: @place.id, submission_id: submission.id))
        end
      end

      context 'with invalid params' do
        it 'does not save an image and redirects to finished page' do
          submission = FactoryBot.create(:submission, place_id: @place.id, status: 'SubmissionName')
          session[:submission_id] = submission.id
          image_attributes = FactoryBot.attributes_for(:image, :with_file)
          expect do
            post :create_image, params: { image: image_attributes, layer_id: @layer.id, place_id: submission.place.id, submission_id: submission.id, locale: 'de' }, session: valid_session
          end.to change(Image, :count).by(0)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(submission_finished_url(layer_id: @layer.id, place_id: @place.id, submission_id: submission.id))
        end
      end
    end
    describe 'GET #finished' do
      it 'returns a success response' do
        submission = Submission.create! valid_attributes
        session[:submission_id] = submission.id
        get :finished, params: { layer_id: @layer.id, submission_id: submission.id, place_id: @place.id, locale: 'de' }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end
end
