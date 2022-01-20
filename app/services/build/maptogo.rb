# frozen_string_literal: true

require 'open3'
include ActionView::Helpers::DateHelper
class Build::Maptogo
  def initialize(current_user, map, layer)
    @current_user = current_user
    @map = map
    @layer = layer
  end

  def build
    build_config = Rails.application.config_for('build/maptogo')
    meta = initialize_meta(build_config)
    data = {}
    build_start = Time.now

    places = @layer.places.published

    client_directory = 'client_xxx'
    render_str = ApplicationController.new.render_to_string(template: 'public/layers/show', formats: :json, locals: { :map => @map, :@layer => @layer, :@places => places })

    if build_config['commands'].length.positive?

      BuildChannel.broadcast_to(
        @current_user,
        {
          content: 'Build process started',
          status: 'start',
          duration: time_ago_in_words(build_start, include_seconds: true)
        }
      )
      build_config['commands'].each_with_index do |cmd, index|
        # cmd.gsub('DATA_URL', 'https://orte.link/public/maps/queer-poems-on-places-and-lovers/layers/queer-poems-on-places-and-lovers.json')
        cmd = cmd.gsub('CLIENT_PATH', client_directory)
        cmd = cmd.gsub('JSON_DATA', render_str)
        Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
          BuildChannel.broadcast_to(
            @current_user,
            {
              index: index,
              status: 'command',
              duration: time_ago_in_words(build_start, include_seconds: true),
              content: "CMD: #{cmd}",
              detail: stdout.read,
              error: stderr.read
            }
          )
        end
      end
      directory_to_zip = "tmp/#{client_directory}/dist/"
      output_file = "public/#{client_directory}.zip"
      zf = ZipFileGenerator.new(directory_to_zip, output_file)
      zf.write
      BuildChannel.broadcast_to(
        @current_user,
        {
          index: 99,
          status: 'finished',
          duration: time_ago_in_words(build_start, include_seconds: true),
          content: "/#{client_directory}.zip"
        }
      )
      # ApplicationController.new.send_data generate_tgz("tmp/" + client_directory + ".zip"), :filename => "tmp/" + client_directory + '.zip'

    end
    result = { meta: meta, data: data }
  end

  private

  def generate_tgz(file)
    content = File.read(file)
    ActiveSupport::Gzip.compress(content)
  end

  def initialize_meta(config)
    {
      version: config['version'] || '1.0.0',
      created_at: DateTime.current.to_s
    }
  end
end
