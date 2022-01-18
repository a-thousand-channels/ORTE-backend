# frozen_string_literal: true

class BuildChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    # stream_from "some_channel"
    stream_from 'build'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
