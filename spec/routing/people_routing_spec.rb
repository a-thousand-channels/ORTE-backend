# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/maps/1/people').to route_to('people#index', map_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/maps/1/people/new').to route_to('people#new', map_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/maps/1/people/1').to route_to('people#show', id: '1', map_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/maps/1/people/1/edit').to route_to('people#edit', id: '1', map_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/maps/1/people').to route_to('people#create', map_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/maps/1/people/1').to route_to('people#update', id: '1', map_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/maps/1/people/1').to route_to('people#update', id: '1', map_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/maps/1/people/1').to route_to('people#destroy', id: '1', map_id: '1')
    end
  end
end
