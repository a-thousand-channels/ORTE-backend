# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildChannel, type: :channel do
  it 'successfully subscribes to the channel' do
    group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, group_id: group.id)
    sign_in user
    subscribe user # subscribe to the channel

    expect(subscription).to be_confirmed # confirm that the subscription was successful
  end
end
