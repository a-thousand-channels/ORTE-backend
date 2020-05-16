# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/maps/1/layers/1/places/1/images').to route_to('images#index', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/maps/1/layers/1/places/1/images/new').to route_to('images#new', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/maps/1/layers/1/places/1/images/1').to route_to('images#show', id: '1', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/maps/1/layers/1/places/1/images/1/edit').to route_to('images#edit', id: '1', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/maps/1/layers/1/places/1/images').to route_to('images#create', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/maps/1/layers/1/places/1/images/1').to route_to('images#update', id: '1', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/maps/1/layers/1/places/1/images/1').to route_to('images#update', id: '1', layer_id: '1', map_id: '1', place_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/maps/1/layers/1/places/1/images/1').to route_to('images#destroy', id: '1', layer_id: '1', map_id: '1', place_id: '1')
    end
  end
end
