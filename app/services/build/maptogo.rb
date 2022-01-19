# frozen_string_literal: true

require 'open3'
include ActionView::Helpers::DateHelper
class Build::Maptogo
  def initialize(current_user)
    @current_user = current_user
  end

  def build
    build_config = Rails.application.config_for('build/maptogo')
    meta = initialize_meta(build_config)
    data = {}
    build_start = Time.now

    if build_config['commands'].length.positive?

      BuildChannel.broadcast_to(
        @current_user,
        {
          content: 'Build process started',
          duration: time_ago_in_words(build_start, include_seconds: true)
        }
      )
      build_config['commands'].each_with_index do |cmd, index|
        Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
          BuildChannel.broadcast_to(
            @current_user,
            {
              index: index,
              duration: time_ago_in_words(build_start, include_seconds: true),
              content: "CMD: #{cmd}",
              detail: stdout.read,
              error: stderr.read
            }
          )
        end
      end
    end
    result = { meta: meta, data: data }
  end

  private

  def initialize_meta(config)
    {
      version: config['version'] || '1.0.0',
      created_at: DateTime.current.to_s
    }
  end
end
