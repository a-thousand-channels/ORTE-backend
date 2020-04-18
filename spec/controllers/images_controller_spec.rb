require 'rails_helper'

RSpec.describe ImagesController, type: :controller do


  describe "functionalities with logged in user with role 'admin'" do

    before do
      @group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, :group_id => @group.id)
      sign_in user
      @place = FactoryBot.create(:place)

    end

    let(:image) {
      FactoryBot.create(:image, :place_id => @place.id)
    }

    let(:valid_attributes) {
      FactoryBot.build(:image, :place_id => @place.id).attributes
    }

    let(:invalid_attributes) {
      FactoryBot.attributes_for(:image, :invalid )
    }

    let(:valid_session) { {} }

    describe "GET #index" do
      it "returns a success response" do
        image = Image.create! valid_attributes
        get :index, params: { :place_id => @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        image = Image.create! valid_attributes
        get :show, params: {id: image.to_param, :place_id => @place.id}, session: valid_session
        expect(response).to have_http_status(302)
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: { :place_id => @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        image = Image.create! valid_attributes
        get :edit, params: {id: image.to_param, :place_id => @place.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Image" do
          expect {
            post :create, params: {image: valid_attributes, :place_id => @place.id}, session: valid_session
          }.to change(Image, :count).by(1)
        end

        it "redirects to the created image" do
          post :create, params: {image: valid_attributes, :place_id => @place.id }, session: valid_session          
          expect(response).to have_http_status(302)
        end        

        it "redirects to related place url" do
          pending
          post :create, params: {image: valid_attributes, :place_id => @place.id }, session: valid_session
          expect(response).to redirect_to(redirect_to place_url(@place))
        end
      end

      context "with invalid params" do
        xit "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {image: invalid_attributes }, session: valid_session
          expect(response).to have_http_status(302)
        end        

        xit "redirects to new image url" do
          post :create, params: {image: invalid_attributes }, session: valid_session
          expect(response).to redirect_to(new_image_url)
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          FactoryBot.attributes_for(:image, :changed, :place_id => @place.id )
        }

        it "updates the requested image" do
          image = Image.create! valid_attributes
          put :update, params: {id: image.to_param, image: new_attributes, :place_id => @place.id }, session: valid_session
          image.reload
          expect(image.title).to eq('OtherTitle')
        end

        xit "redirects to the place" do
          image = Image.create! valid_attributes
          put :update, params: {id: image.to_param, image: valid_attributes, :place_id => @place.id }, session: valid_session
          expect(response).to redirect_to(place_url(@place))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          image = Image.create! valid_attributes
          put :update, params: {id: image.to_param, image: invalid_attributes, :place_id => @place.id}, session: valid_session
          expect(response).to have_http_status(302)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested image" do
        image = Image.create! valid_attributes
        expect {
          delete :destroy, params: {id: image.to_param, :place_id => @place.id}, session: valid_session
        }.to change(Image, :count).by(-1)
      end

      xit "redirects to the images list" do
        image = Image.create! valid_attributes
        delete :destroy, params: {id: image.to_param, :place_id => @place.id}, session: valid_session
        expect(response).to redirect_to(place_url(@place))
      end
    end
  end
end
