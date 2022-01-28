# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildLogsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/build_logs').to route_to('build_logs#index')
    end

    it 'routes to #new' do
      expect(get: '/build_logs/new').to route_to('build_logs#new')
    end

    it 'routes to #show' do
      expect(get: '/build_logs/1').to route_to('build_logs#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/build_logs/1/edit').to route_to('build_logs#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/build_logs').to route_to('build_logs#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/build_logs/1').to route_to('build_logs#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/build_logs/1').to route_to('build_logs#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/build_logs/1').to route_to('build_logs#destroy', id: '1')
    end
  end
end
