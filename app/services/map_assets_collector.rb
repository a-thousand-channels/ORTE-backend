# frozen_string_literal: true

require 'open3'
require 'fileutils'
include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

# Map Assets Collector
# Before there were some procedures to save/export Layers with their images
# This is for the Map level and includes all assets defined (images, audios, videos)

class MapAssetsCollector
  def initialize(map)
    @map = map
  end

  def prepare
    today = Date.current.strftime('%Y-%m-%d--%H-%M')
    filename = "#{@map.friendly_id}_data_and_assets_export_#{today}"
    assets_tmp_folder = "tmp/#{filename}_assets"
    output_file = "public/#{filename}.zip"

    map_data, assets_on_disc = generate_map_json
    puts "Map data and assets collected for map #{@map.title} (#{@map.id})"
    puts assets_on_disc.inspect
    puts '##########################'
    tmp_file = "#{assets_tmp_folder}/#{@map.friendly_id}.json"
    File.write(tmp_file, JSON.generate(map_data))

    FileUtils.mkdir_p assets_tmp_folder
    return unless Dir.exist?(assets_tmp_folder)

    assets_on_disc.each do |file_hash|
      puts "Copying asset #{file_hash[:filename]} to #{assets_tmp_folder}"
      dest_file = "#{assets_tmp_folder}/#{file_hash[:filename]}"
      FileUtils.cp(file_hash[:disk], dest_file)
    end

    filesize = 0

    zf = ZipFileGenerator.new(assets_tmp_folder, output_file)
    zf.write
    filesize = number_to_human_size(File.size(Pathname.new(output_file)))

    FileUtils.rm_rf(assets_tmp_folder)
  end

  def generate_map_json(assets_path = '/assets/')
    puts "Generating JSON for map #{@map.title} (#{@map.id}) #{@map.published ? 'published' : 'not published'}"
    controller = ApplicationController.new
    controller.instance_variable_set(:@map, @map)
    controller.instance_variable_set(:@map_layers, @map.layers.published)
    json_data = controller.render_to_string(template: 'public/maps/show', formats: :json)

    map_data = JSON.parse(json_data, { symbolize_names: true })

    # layer assets
    # TODO: enable this after full implementation in the layer model

    # places and places pages assets
    assets_on_disc = @map.layers.published.flat_map { |layer| collect_places_assets(layer.places, assets_path) }

    [map_data, assets_on_disc]
  end

  private

  def collect_places_assets(places, assets_path)
    places.each_with_object([]) do |place, assets|
      next unless place.published?

      # places assets
      assets.concat(collect_images_assets(place.images, assets_path))
      assets.concat(collect_audios_assets(place.audios, assets_path))

      # pages of places assets
      assets.concat(collect_pages_assets(place.pages, assets_path))
    end
  end

  def collect_pages_assets(pages, assets_path)
    pages.each_with_object([]) do |page, assets|
      next unless page.published?

      assets.concat(collect_images_assets(page.images, assets_path))
    end
  end

  def collect_images_assets(images, assets_path)
    images.each_with_object([]) do |image, assets|
      next unless image.published?
      next unless image.image_on_disk.present?

      img = read_image(image, assets_path)
      assets << img unless img.nil?
    end
  end

  def collect_audios_assets(audios, assets_path)
    audios.each_with_object([]) do |audio, assets|
      next unless audio.published?
      next unless audio.audio_on_disk.present?

      aud = read_audio(audio, assets_path)
      assets << aud unless aud.nil?
    end
  end

  def read_audio(audio, assets_path = '/assets/')
    return nil unless audio.audio_on_disk.present?

    { atype: 'audio', filename: audio.audio_filename.to_s, disk: Rails.root.to_s + audio.audio_on_disk }
  end

  def read_image(image, assets_path = '/assets/')
    return nil unless image.image_on_disk.present?

    { atype: 'image', filename: image.image_filename.to_s, disk: Rails.root.to_s + image.image_on_disk }
  end

  def generate_tgz(file)
    content = File.read(file)
    ActiveSupport::Gzip.compress(content)
  end
end
