# frozen_string_literal: true

require 'open3'
require 'fileutils'
include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper
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

    rand_id = SecureRandom.uuid

    client_directory = "client_#{rand_id}"
    tmp_file = "tmp/client_#{rand_id}.json"
    directory_client = "tmp/#{client_directory}"
    directory_to_zip = "tmp/#{client_directory}/dist/"
    output_file = "public/#{client_directory}.zip"

    json_data = ApplicationController.new.render_to_string(template: 'public/layers/show', formats: :json, locals: { :map => @map, :@layer => @layer, :@places => places })

    layer = JSON.parse(json_data, { symbolize_names: true })
    places = layer[:layer][:places]
    images_on_disc = []
    places.each do |place|
      images = place[:images]
      images.each do |image|
        image[:image_url] = "/images/#{image[:image_filename]}"
        images_on_disc << { 'filename' => image[:image_filename], 'disk' => Rails.root.to_s + (image[:image_on_disk]) }
      end
    end
    File.open(tmp_file, 'w') { |file| file.write(JSON.generate(layer)) }

    images_tmp_folder = "tmp/#{directory_client}/images"
    FileUtils.mkdir_p images_tmp_folder

    images_on_disc.each do |file_hash|
      dest_folder = "#{images_tmp_folder}/#{file_hash['filename']}"
      FileUtils.cp(file_hash['disk'], dest_folder)
    end

    if build_config['commands'].length.positive?
      step_count = build_config['commands'].count
      BuildChannel.broadcast_to(
        @current_user,
        {
          content: "Build process started (#{build_config['commands'].count} Steps)",
          status: 'start',
          step_count: step_count,
          duration: time_ago_in_words(build_start, include_seconds: true)
        }
      )

      build_config['commands'].each_with_index do |command, index|
        BuildChannel.broadcast_to(
          @current_user,
          {
            index: index,
            status: 'pre-command',
            duration: time_ago_in_words(build_start, include_seconds: true),
            content: (command['label']).to_s,
            step_count: step_count
          }
        )
        cmd = command['cmd'].gsub('CLIENT_PATH', client_directory)
        cmd = cmd.gsub('JSON_FILE', tmp_file)
        cmd = cmd.gsub('IMAGE_FILE_DIRECTORY', images_tmp_folder)
        Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
          sleep 2
          BuildChannel.broadcast_to(
            @current_user,
            {
              index: index,
              status: 'command',
              duration: time_ago_in_words(build_start, include_seconds: true),
              content: (command['label']).to_s,
              step_count: step_count,
              command: cmd,
              detail: stdout.read,
              error: stderr.read,
              cmd_status: wait_thr.value.to_s
            }
          )
        end
      end

      zf = ZipFileGenerator.new(directory_to_zip, output_file)
      zf.write
      filesize = number_to_human_size(File.size(Pathname.new(output_file)))
      FileUtils.rm_rf(directory_client)
      FileUtils.rm_rf(images_tmp_folder)
      BuildChannel.broadcast_to(
        @current_user,
        {
          index: 99,
          status: 'finished',
          duration: "#{((Time.current - build_start) / 1.second).round} seconds",
          content: "/#{client_directory}.zip",
          step_count: step_count,
          filesize: filesize
        }
      )
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
