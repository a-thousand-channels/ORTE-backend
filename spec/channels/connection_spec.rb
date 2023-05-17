# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:group) { create(:group) }
  let(:user) { create(:admin_user, group_id: group.id) }

  context 'when a user is authorized' do
    before do
      env = { 'warden' => double('Warden', user: user) }
      allow_any_instance_of(ApplicationCable::Connection).to receive(:env).and_return(env)
    end

    it 'successfully connects' do
      connect '/cable' # connect to the Action Cable server
      expect(connection.current_user).to eq(user) # expect the current_user to be set to the created user
      expect(connection).to be_truthy
    end
  end

  context 'when no user is authorized' do
    before do
      stub_connection(current_user: user)
    end
    it 'rejects connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end
end
