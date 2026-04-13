# frozen_string_literal: true

json.extract! page, :id, :title, :subtitle, :text, :footer, :published, :map_id, :created_at, :updated_at
json.url map_page_url(page, format: :json)
