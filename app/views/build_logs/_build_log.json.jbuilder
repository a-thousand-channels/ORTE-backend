# frozen_string_literal: true

json.extract! build_log, :id, :map_id, :layer_id, :output, :size, :version, :created_at, :updated_at
json.url build_log_url(build_log, format: :json)
