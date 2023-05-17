# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildChannel, type: :channel do
  let(:group) { create(:group) }
  let(:user) { create(:admin_user, group_id: group.id) }

  before do
    stub_connection(current_user: user)
  end
  it 'successfully subscribes to the channel' do
    subscribe # subscribe to the BuildChannel
    expect(subscription).to be_confirmed # confirm that the subscription was successful
  end
end
