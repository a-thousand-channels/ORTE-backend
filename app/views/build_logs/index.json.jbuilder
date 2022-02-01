# frozen_string_literal: true

json.array! @build_logs, partial: 'build_logs/build_log', as: :build_log
