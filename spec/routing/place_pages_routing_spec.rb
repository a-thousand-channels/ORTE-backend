# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routing for pages connected to a place (locale scope)' do
    it 'routes to #index' do
      expect(get: '/en/maps/1/layers/1/places/1/pages').to route_to('pages#index', locale: 'en', place_id: '1', layer_id: '1', map_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/en/maps/1/layers/1/places/1/pages/new').to route_to('pages#new', locale: 'en', place_id: '1', layer_id: '1', map_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/en/maps/1/layers/1/places/1/pages/1').to route_to('pages#show', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/en/maps/1/layers/1/places/1/pages/1/edit').to route_to('pages#edit', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/en/maps/1/layers/1/places/1/pages').to route_to('pages#create', locale: 'en', place_id: '1', layer_id: '1', map_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/en/maps/1/layers/1/places/1/pages/1').to route_to('pages#update', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/en/maps/1/layers/1/places/1/pages/1').to route_to('pages#update', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/en/maps/1/layers/1/places/1/pages/1').to route_to('pages#destroy', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1')
    end

    describe 'member routes' do
      it 'routes to #images via images_overview path' do
        expect(get: '/en/maps/1/layers/1/places/1/pages/1/images_overview').to route_to(
          'pages#images', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1'
        )
      end

      it 'routes to #sort' do
        expect(post: '/en/maps/1/layers/1/places/1/pages/1/sort').to route_to(
          'pages#sort', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', id: '1'
        )
      end
    end

    describe 'nested image routes' do
      it 'routes to images#index' do
        expect(get: '/en/maps/1/layers/1/places/1/pages/1/images').to route_to(
          'images#index', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', page_id: '1'
        )
      end

      it 'routes to images#create' do
        expect(post: '/en/maps/1/layers/1/places/1/pages/1/images').to route_to(
          'images#create', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', page_id: '1'
        )
      end
    end

    describe 'nested video routes' do
      it 'routes to videos#index' do
        expect(get: '/en/maps/1/layers/1/places/1/pages/1/videos').to route_to(
          'videos#index', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', page_id: '1'
        )
      end

      it 'routes to videos#create' do
        expect(post: '/en/maps/1/layers/1/places/1/pages/1/videos').to route_to(
          'videos#create', locale: 'en', place_id: '1', layer_id: '1', map_id: '1', page_id: '1'
        )
      end
    end

    describe 'locale handling' do
      %w[de fr it nl pl ru].each do |locale|
        it "routes correctly with #{locale} locale" do
          expect(get: "/#{locale}/maps/1/layers/1/places/1/pages").to route_to(
            'pages#index', locale: locale, place_id: '1', layer_id: '1', map_id: '1'
          )
        end

        it "routes to #show with #{locale} locale" do
          expect(get: "/#{locale}/maps/1/layers/1/places/1/pages/1").to route_to(
            'pages#show', locale: locale, place_id: '1', layer_id: '1', map_id: '1', id: '1'
          )
        end
      end

      it 'passes the locale parameter correctly to the controller' do
        expect(get: '/de/maps/1/layers/1/places/1/pages').to route_to('pages#index', locale: 'de', place_id: '1', layer_id: '1', map_id: '1')
      end

      it 'distinguishes locale in the route parameters' do
        expect(get: '/fr/maps/1/layers/1/places/1/pages/1').to route_to(
          'pages#show', locale: 'fr', place_id: '1', layer_id: '1', map_id: '1', id: '1'
        )
      end
    end
  end
end
