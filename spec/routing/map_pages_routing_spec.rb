# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routing for pages connected to a map (locale scope)' do
    it 'routes to #index' do
      expect(get: '/en/maps/1/pages').to route_to('pages#index', locale: 'en', map_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/en/maps/1/pages/new').to route_to('pages#new', locale: 'en', map_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/en/maps/1/pages/1').to route_to('pages#show', locale: 'en', map_id: '1', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/en/maps/1/pages/1/edit').to route_to('pages#edit', locale: 'en', map_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/en/maps/1/pages').to route_to('pages#create', locale: 'en', map_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/en/maps/1/pages/1').to route_to('pages#update', locale: 'en', map_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/en/maps/1/pages/1').to route_to('pages#update', locale: 'en', map_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/en/maps/1/pages/1').to route_to('pages#destroy', locale: 'en', map_id: '1', id: '1')
    end

    describe 'member routes' do
      it 'routes to #images via images_overview path' do
        expect(get: '/en/maps/1/pages/1/images_overview').to route_to(
          'pages#images', locale: 'en', map_id: '1', id: '1'
        )
      end

      it 'routes to #sort' do
        expect(post: '/en/maps/1/pages/1/sort').to route_to(
          'pages#sort', locale: 'en', map_id: '1', id: '1'
        )
      end
    end

    describe 'nested image routes' do
      it 'routes to images#index' do
        expect(get: '/en/maps/1/pages/1/images').to route_to(
          'images#index', locale: 'en', map_id: '1', page_id: '1'
        )
      end

      it 'routes to images#create' do
        expect(post: '/en/maps/1/pages/1/images').to route_to(
          'images#create', locale: 'en', map_id: '1', page_id: '1'
        )
      end
    end

    describe 'nested video routes' do
      it 'routes to videos#index' do
        expect(get: '/en/maps/1/pages/1/videos').to route_to(
          'videos#index', locale: 'en', map_id: '1', page_id: '1'
        )
      end

      it 'routes to videos#create' do
        expect(post: '/en/maps/1/pages/1/videos').to route_to(
          'videos#create', locale: 'en', map_id: '1', page_id: '1'
        )
      end
    end
  end
end
