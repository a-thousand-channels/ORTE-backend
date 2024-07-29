# frozen_string_literal: true

json.extract! relation, :id, :created_at, :updated_at
json.url relation_url(relation, format: :json)
