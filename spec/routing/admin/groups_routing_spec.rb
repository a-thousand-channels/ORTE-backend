# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::GroupsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/groups').to route_to('admin/groups#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/groups/new').to route_to('admin/groups#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/groups/1').to route_to('admin/groups#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/groups/1/edit').to route_to('admin/groups#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/groups').to route_to('admin/groups#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/groups/1').to route_to('admin/groups#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/groups/1').to route_to('admin/groups#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/groups/1').to route_to('admin/groups#destroy', id: '1')
    end
  end
end
