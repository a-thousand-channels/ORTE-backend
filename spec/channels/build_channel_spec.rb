require "rails_helper"

RSpec.describe BuildChannel, type: :channel do
  it "rejects when no current_user" do
    subscribe
    expect(subscription).to be_rejected
  end

  it "successfully subscribes" do
    subscribed(room_id: 42)
    expect(subscription).to be_confirmed
    expect(streams).to include("42")
  end
end