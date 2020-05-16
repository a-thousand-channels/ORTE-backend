# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IconsetsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/iconsets').to route_to('iconsets#index')
    end

    it 'routes to #new' do
      expect(get: '/iconsets/new').to route_to('iconsets#new')
    end

    it 'routes to #show' do
      expect(get: '/iconsets/1').to route_to('iconsets#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/iconsets/1/edit').to route_to('iconsets#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/iconsets').to route_to('iconsets#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/iconsets/1').to route_to('iconsets#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/iconsets/1').to route_to('iconsets#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/iconsets/1').to route_to('iconsets#destroy', id: '1')
    end
  end
end
