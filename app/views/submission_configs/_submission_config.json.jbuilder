# frozen_string_literal: true

json.extract! submission_config, :id, :title_intro, :subtitle_intro, :intro, :title_outro, :outro, :start_time, :end_time, :use_city_only, :created_at, :updated_at
json.url submission_config_url(submission_config, format: :json)
