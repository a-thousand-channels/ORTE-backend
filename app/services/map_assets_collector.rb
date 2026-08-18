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

  def prepare(output_filename)
    # puts "Preparing map #{@map.title} (#{@map.id}) for export to #{output_filename}"
    return unless @map.published

    assets_tmp_folder = "tmp/#{output_filename}_assets"
    output_file = "public/#{output_filename}"

    FileUtils.mkdir_p assets_tmp_folder
    return unless Dir.exist?(assets_tmp_folder)

    map_data, assets_on_disc = generate_map_json
    tmp_file = "#{assets_tmp_folder}/#{@map.friendly_id}.json"
    File.write(tmp_file, JSON.generate(map_data))

    assets_on_disc.each do |file_hash|
      # puts "Copying asset #{file_hash[:filename]} to #{assets_tmp_folder}"
      dest_file = "#{assets_tmp_folder}/#{file_hash[:filename]}"
      FileUtils.cp(file_hash[:disk], dest_file)
    end

    filesize = 0

    zf = ZipFileGenerator.new(assets_tmp_folder, output_file)
    zf.write
    filesize = number_to_human_size(File.size(Pathname.new(output_file)))

    FileUtils.rm_rf(assets_tmp_folder)
    output_file
  end

  def generate_map_json(assets_path = '/assets/')
    # puts "Generating JSON for map #{@map.title} (#{@map.id}) #{@map.published ? 'published' : 'not published'}"
    controller = ApplicationController.new
    controller.instance_variable_set(:@map, @map)
    controller.instance_variable_set(:@map_layers, map_layers_with_published_places)
    json_data = controller.render_to_string(template: 'public/maps/show', formats: :json)

    map_data = JSON.parse(json_data, { symbolize_names: true })

    # layer assets
    # TODO: enable this after full implementation in the layer model

    # places and places pages assets - an unpublished map renders as `{ map: {} }` above
    # (see public/maps/show.json.jbuilder), so don't bundle real files for it either
    assets_on_disc = @map.published ? @map.layers.published.flat_map { |layer| collect_places_assets(layer.places, assets_path) } : []

    # per-map filename collisions (e.g. two places both attaching "photo.jpg") would otherwise
    # overwrite each other once copied into the flat assets folder, so make them unique here and
    # keep the rendered JSON in sync with the names actually used in the export
    assets_on_disc = dedupe_and_patch_filenames(map_data, assets_on_disc)

    [map_data, assets_on_disc]
  end

  private

  # Mirrors Public::MapsController#show, which drops layers that end up with no
  # published places once the places join filter is applied - kept in sync so the
  # export JSON matches what the public map endpoint actually renders.
  def map_layers_with_published_places
    layers = @map.layers.published
    return layers unless layers.present?

    layers
      .includes(:image_attachment, places: [:icon, :annotations, :tags, :audios, :videos, { images: { file_attachment: :blob }, pages: {}, relations_froms: %i[relation_from relation_to] }])
      .where(places: { published: true })
  end

  def dedupe_and_patch_filenames(map_data, assets_on_disc)
    assets_on_disc = dedupe_filenames(assets_on_disc)
    patch_json_filenames!(map_data, assets_on_disc)
    assets_on_disc
  end

  def dedupe_filenames(assets_on_disc)
    deduper = AssetFilenameDeduper.new
    assets_on_disc.sort_by { |asset| asset[:id] }.each do |asset|
      asset[:filename] = deduper.unique_name_for(asset[:filename])
    end
  end

  def patch_json_filenames!(map_data, assets_on_disc)
    filenames_by_atype_and_id = assets_on_disc.to_h { |asset| [[asset[:atype], asset[:id]], asset[:filename]] }

    map_data.dig(:map, :layer)&.each do |layer|
      layer[:places]&.each { |place| patch_place_filenames!(place, filenames_by_atype_and_id) }
    end
  end

  def patch_place_filenames!(place, filenames_by_atype_and_id)
    place[:images]&.each do |image|
      new_filename = filenames_by_atype_and_id[['image', image[:id]]]
      image[:image_filename] = new_filename if new_filename
    end
    place[:audios]&.each do |audio|
      new_filename = filenames_by_atype_and_id[['audio', audio[:id]]]
      audio[:audio_filename] = new_filename if new_filename
    end
  end

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

  def read_audio(audio, _assets_path = '/assets/')
    return nil unless audio.audio_on_disk.present?

    { atype: 'audio', id: audio.id, filename: audio.audio_filename.to_s, disk: Rails.root.to_s + audio.audio_on_disk }
  end

  def read_image(image, _assets_path = '/assets/')
    return nil unless image.image_on_disk.present?

    { atype: 'image', id: image.id, filename: image.image_filename.to_s, disk: Rails.root.to_s + image.image_on_disk }
  end

  def generate_tgz(file)
    content = File.read(file)
    ActiveSupport::Gzip.compress(content)
  end
end
