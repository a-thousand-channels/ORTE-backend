require "rails_helper"

include ActionCable::TestHelper
RSpec.describe BuildChannel, :type => :channel do
  it "successfully subscribes" do
    subscribe room_id: 42
    expect(subscription).to be_confirmed
  end
end