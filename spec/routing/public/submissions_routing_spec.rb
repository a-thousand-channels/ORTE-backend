# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::SubmissionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/de/1/submissions/new').to route_to('public/submissions#new', locale: 'de', layer_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/de/1/submissions/1/edit').to route_to('public/submissions#edit', locale: 'de', layer_id: '1', id: '1')
    end

    it 'routes to #index' do
      expect(get: '/de/1/submissions').to route_to('public/submissions#index', locale: 'de', layer_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/de/1/submissions').to route_to('public/submissions#create', locale: 'de', layer_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/de/1/submissions/1').to route_to('public/submissions#update', locale: 'de', layer_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/de/1/submissions/1').to route_to('public/submissions#update', locale: 'de', layer_id: '1', id: '1')
    end
  end
end
