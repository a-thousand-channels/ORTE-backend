# frozen_string_literal: true

json.extract! iconset, :id, :title, :text, :image, :created_at, :updated_at
json.url iconset_url(iconset, format: :json)
