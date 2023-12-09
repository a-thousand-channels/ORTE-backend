# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LayersController, type: :controller do
  # needed for json builder test, since json builder files are handled as views:
  render_views

  describe "functionalities with logged in user with role 'admin'" do
    before do
      group = FactoryBot.create(:group)
      user = FactoryBot.create(:admin_user, group_id: group.id)
      sign_in user
      @map = FactoryBot.create(:map, group_id: group.id)
    end

    let(:layer) do
      FactoryBot.create(:layer, map_id: @map.id)
    end

    let(:valid_attributes) do
      FactoryBot.build(:layer, map_id: @map.id).attributes
    end

    let(:invalid_attributes) do
      FactoryBot.attributes_for(:layer, :invalid, map_id: @map.id)
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # LayersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET #index' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :index, params: { map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #images' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :images, params: { map_id: @map.id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #pack' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :pack, params: { map_id: @map.id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #build' do
      xit 'returns a success response' do
        layer = Layer.create! valid_attributes
        patch :build, params: { map_id: @map.id, id: layer.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #search' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :search, params: { map_id: @map.id, q: { query: 'Nope' } }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        place = FactoryBot.create(:place, layer_id: layer.id, title: 'Test')
        get :search, params: { map_id: @map.id, q: { query: 'Test' } }, session: valid_session
        expect(assigns(:places)).to eq([place])
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :show, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end
      it 'returns a redirect to an friendly_id' do
        layer = Layer.create! valid_attributes
        get :show, params: { map_id: @map.friendly_id, id: layer.id }, session: valid_session
        expect(response).to have_http_status(301)
      end
      it 'returns a no success response (for a non-accesible map)' do
        another_group = FactoryBot.create(:group)
        map = FactoryBot.create(:map, group_id: another_group.id)
        layer = FactoryBot.create(:layer, map_id: map.id)
        get :show, params: { map_id: map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to match 'Sorry, this map could not be found.'
      end

      it 'returns a sucess with use_background_from_parent_map=true' do
        layer = FactoryBot.create(:layer, :use_background_from_parent_map, map: @map)
        get :show, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:layer)['use_background_from_parent_map']).to be_truthy
        expect(assigns(:layer)['basemap_url']).to eq('MyMapBasemapUrl')
      end
    end

    describe 'GET #show as json' do
      it 'returns a success reponse' do
        layer = Layer.create! valid_attributes
        get :show, params: { id: layer.friendly_id, map_id: @map.friendly_id }, session: valid_session, format: 'json'
        expect(response).to have_http_status(200)
      end

      it 'a layer w/title for a published layer' do
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        get :show, params: { id: layer.friendly_id, map_id: @map.friendly_id }, session: valid_session, format: 'json'
        json = JSON.parse(response.body)
        expect(json['title']).to eq layer.title
      end

      it 'a layer with all places' do
        layer = Layer.create! valid_attributes
        layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
        p1 = FactoryBot.create(:place, :published, layer_id: layer.id, title: 'Place1')
        p2 = FactoryBot.create(:place, :published, layer_id: layer.id, title: 'Place2')
        p3 = FactoryBot.create(:place, layer_id: layer.id, title: 'Place3')
        get :show, params: { id: layer.friendly_id, map_id: @map.friendly_id }, session: valid_session, format: 'json'
        json = JSON.parse(response.body)
        expect(json['places'][0]['title']).to eq p1.title
        expect(json['places'][1]['title']).to eq p2.title
        expect(json['places'][2]['title']).to eq p3.title
        expect(json['places'][2]['edit_link']).to match(/pencil/)
        expect(json['places'][2]['show_link']).to match(/#{p3.title}/)
      end

      xit 'a layer with published places and some attached images' do
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: { map_id: @map.id }, session: valid_session
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        layer = Layer.create! valid_attributes
        get :edit, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response with no color set' do
        layer = FactoryBot.create(:layer, :with_no_color, map: @map)
        get :edit, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
      end

      it 'returns a success response with_wrong_color_format set' do
        layer = FactoryBot.create(:layer, :with_wrong_color_format, map: @map)
        get :edit, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:layer)['color']).to eq('#cc0000')
      end

      it 'returns a sucess with use_background_from_parent_map=true' do
        layer = FactoryBot.create(:layer, :use_background_from_parent_map, map: @map)
        get :edit, params: { map_id: @map.friendly_id, id: layer.friendly_id }, session: valid_session
        expect(response).to have_http_status(200)
        expect(assigns(:layer)['use_background_from_parent_map']).to be_truthy
        expect(assigns(:layer)['basemap_url']).to eq('MyMapBasemapUrl')
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Layer' do
          expect do
            post :create, params: { map_id: @map.friendly_id, layer: valid_attributes }, session: valid_session
          end.to change(Layer, :count).by(1)
        end

        it 'redirects to the map' do
          post :create, params: { map_id: @map.friendly_id, layer: valid_attributes }, session: valid_session
          layer = Layer.last
          expect(response).to redirect_to(map_layer_path(@map.friendly_id, layer))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { map_id: @map.id, layer: invalid_attributes }, session: valid_session
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'POST #create with image layer' do
      let(:image_layer) do
        FactoryBot.create(:layer, :with_ltype_image, map_id: @map.id)
      end

      let(:images_files) do
        [
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg'),
          Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', 'test-with-exif-data.jpg'), 'image/jpeg')
        ]
      end

      let(:valid_image_layer_attributes) do
        FactoryBot.build(:layer, :with_ltype_image, map_id: @map.id).attributes
      end

      context 'with valid params' do
        before do
          # HINT: none-model values must be merge into the factory here
          valid_image_layer_attributes.merge!(images_files: images_files)
        end

        it 'creates a new Layer' do
          expect do
            post :create, params: { map_id: @map.friendly_id, layer: valid_image_layer_attributes }, session: valid_session
          end.to change(Layer, :count).by(1)
                                      .and change(Place, :count).by(3)
                                                                .and change(Image, :count).by(3)
          expect(Place.last.lon).to eq('10.0')
          expect(flash[:notice]).to match 'Layer was created with 3 geocoded images.'
        end

        it 'redirects to the map' do
          post :create, params: { map_id: @map.friendly_id, layer: valid_image_layer_attributes }, session: valid_session
          layer = Layer.last
          expect(response).to redirect_to(map_layer_path(@map.friendly_id, layer))
        end
      end

      context 'with invalid params (images are missing)' do
        it 'doest not create a new Layer' do
          expect do
            post :create, params: { map_id: @map.friendly_id, layer: valid_image_layer_attributes }, session: valid_session
          end.not_to change(Place, :count)
          expect(flash[:alert]).to match 'This is an image layer, but no images has been provided.'
        end

        it 'redirects to the map' do
          post :create, params: { map_id: @map.friendly_id, layer: valid_image_layer_attributes }, session: valid_session
          layer = Layer.last
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          FactoryBot.build(:layer, :changed, map_id: @map.id).attributes
        end

        it 'updates the requested layer' do
          layer = Layer.create! valid_attributes
          put :update, params: { map_id: @map.id, id: layer.id, layer: new_attributes }, session: valid_session
          layer.reload
          expect(layer.title).to eq('OtherTitle')
          expect(layer.image_alt).to eq('An alternative text')
        end

        it 'redirects to the layer' do
          layer = Layer.create! valid_attributes
          put :update, params: { map_id: @map.id, id: layer.id, layer: valid_attributes }, session: valid_session
          expect(response).to redirect_to(map_layer_path(@map.friendly_id, layer))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          layer = Layer.create! valid_attributes
          put :update, params: { map_id: @map.id, id: layer.friendly_id, layer: invalid_attributes }, session: valid_session
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested layer' do
        layer = Layer.create! valid_attributes
        expect do
          delete :destroy, params: { map_id: @map.id, id: layer.friendly_id }, session: valid_session
        end.to change(Layer, :count).by(-1)
      end

      it 'redirects to the layers list' do
        layer = Layer.create! valid_attributes
        delete :destroy, params: { map_id: @map.id, id: layer.friendly_id }, session: valid_session
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

      let(:layer) do
        FactoryBot.create(:layer, :with_ltype_image, map_id: @map.id)
      end

      let(:valid_image_layer_attributes) do
        layer.attributes
      end

      context 'with valid image files' do
        before do
          valid_image_layer_attributes.merge!(images_files: images_files)
        end

        it 'returns true' do
          controller.params[:layer] = valid_image_layer_attributes
          expect(controller.send(:validate_images_format)).to be_truthy
        end
      end

      context 'with image files without geocoding' do
        before do
          valid_image_layer_attributes.merge!(images_files: falsey_images_files)
        end

        it 'returns true' do
          controller.params[:layer] = valid_image_layer_attributes
          expect(controller.send(:validate_images_format)).to be_truthy
        end
      end

      context 'with invalid image files' do
        before do
          valid_image_layer_attributes.merge!(images_files: no_images_files)
        end

        it 'adds an error to the layer' do
          controller.params[:layer] = valid_image_layer_attributes
          expect(controller.send(:validate_images_format)).to be_falsey
          expect(flash[:alert]).to match 'Invalid file formats found. Only JPEG, PNG and GIF are allowed.'
        end
      end
    end
  end
end
