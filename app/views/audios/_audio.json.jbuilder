# frozen_string_literal: true

json.extract! audio, :id, :title, :licence, :source, :creator, :alt, :caption, :sorting, :preview, :created_at, :updated_at
json.url audio_url(audio, format: :json)
