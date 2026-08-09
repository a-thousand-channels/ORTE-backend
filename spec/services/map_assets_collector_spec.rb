# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapAssetsCollector do
  let(:map) { FactoryBot.create(:map, published: true) }
  let(:layer) { FactoryBot.create(:layer, map: map, published: true) }
  let(:place) { FactoryBot.create(:place, layer: layer, published: true) }
  let(:collector) { described_class.new(map) }

  def attach_jpg(record, filename)
    record.file.attach(
      io: File.open(Rails.root.join('spec/support/files/test.jpg')),
      filename: filename,
      content_type: 'image/jpeg'
    )
  end

  describe '#generate_map_json' do
    it 'returns the same JSON the public map endpoint would render' do
      image = FactoryBot.create(:image, imageable: place)
      attach_jpg(image, 'photo.jpg')

      controller = ApplicationController.new
      controller.instance_variable_set(:@map, map)
      controller.instance_variable_set(:@map_layers, map.layers.published)
      expected = JSON.parse(controller.render_to_string(template: 'public/maps/show', formats: :json), symbolize_names: true)

      map_data, = collector.generate_map_json
      expect(map_data).to eq(expected)
    end

    it 'collects a disk-backed asset entry per published image and audio' do
      image = FactoryBot.create(:image, imageable: place)
      attach_jpg(image, 'photo.jpg')

      audio = FactoryBot.create(:audio, audioable: place, locale: 'en')
      audio.file.attach(
        io: File.open(Rails.root.join('spec/support/files/test.mp3')),
        filename: 'sound.mp3',
        content_type: 'audio/mpeg'
      )

      _, assets_on_disc = collector.generate_map_json

      expect(assets_on_disc).to contain_exactly(
        { atype: 'image', id: image.id, filename: 'photo.jpg', disk: a_string_matching(/.+/) },
        { atype: 'audio', id: audio.id, filename: 'sound.mp3', disk: a_string_matching(/.+/) }
      )
      assets_on_disc.each { |asset| expect(File.exist?(asset[:disk])).to be true }
    end

    it 'excludes assets belonging to unpublished images, audios, places and layers' do
      published_image = FactoryBot.create(:image, imageable: place)
      attach_jpg(published_image, 'published.jpg')

      unpublished_image = FactoryBot.create(:image, imageable: place, published: false)
      attach_jpg(unpublished_image, 'unpublished_image.jpg')

      other_place = FactoryBot.create(:place, layer: layer, published: false)
      other_place_image = FactoryBot.create(:image, imageable: other_place)
      attach_jpg(other_place_image, 'unpublished_place.jpg')

      other_layer = FactoryBot.create(:layer, map: map, published: false)
      other_layer_place = FactoryBot.create(:place, layer: other_layer, published: true)
      other_layer_image = FactoryBot.create(:image, imageable: other_layer_place)
      attach_jpg(other_layer_image, 'unpublished_layer.jpg')

      _, assets_on_disc = collector.generate_map_json

      expect(assets_on_disc.map { |a| a[:filename] }).to eq(['published.jpg'])
    end

    it 'collects assets from published pages of a place' do
      page = FactoryBot.create(:page, pageable: place, published: true)
      page_image = FactoryBot.create(:image, imageable: page)
      attach_jpg(page_image, 'page_photo.jpg')

      _, assets_on_disc = collector.generate_map_json

      expect(assets_on_disc.map { |a| a[:filename] }).to include('page_photo.jpg')
    end

    it 'dedupes colliding filenames and reflects the new names in the JSON' do
      image1 = FactoryBot.create(:image, imageable: place)
      attach_jpg(image1, 'photo.jpg')
      image2 = FactoryBot.create(:image, imageable: place)
      attach_jpg(image2, 'photo.jpg')

      map_data, assets_on_disc = collector.generate_map_json

      expect(assets_on_disc.map { |a| a[:filename] }.sort).to eq(%w[photo-1.jpg photo.jpg])

      json_filenames = map_data[:map][:layer].flat_map { |l| l[:places] }.flat_map { |p| p[:images] }.map { |i| i[:image_filename] }
      expect(json_filenames.sort).to eq(%w[photo-1.jpg photo.jpg])
    end

    context 'when the map itself is unpublished' do
      let(:map) { FactoryBot.create(:map, published: false) }

      it 'renders an empty map and collects no assets, even though the layer/place/image are published' do
        image = FactoryBot.create(:image, imageable: place)
        attach_jpg(image, 'photo.jpg')

        map_data, assets_on_disc = collector.generate_map_json

        expect(map_data).to eq({})
        expect(assets_on_disc).to eq([])
      end
    end
  end

  describe '#prepare' do
    after { FileUtils.rm_f(@zip_path) if @zip_path }

    it 'returns exactly the path the caller asked for, without adding a second .zip extension' do
      image = FactoryBot.create(:image, imageable: place)
      attach_jpg(image, 'photo.jpg')

      @zip_path = collector.prepare('collector_prepare_spec_output.zip')

      expect(@zip_path).to eq('public/collector_prepare_spec_output.zip')
      expect(File.exist?(@zip_path)).to be true
    end

    context 'when the map itself is unpublished' do
      let(:map) { FactoryBot.create(:map, published: false) }

      it 'produces no zip file at all' do
        image = FactoryBot.create(:image, imageable: place)
        attach_jpg(image, 'photo.jpg')

        @zip_path = collector.prepare('collector_prepare_unpublished_spec_output.zip')

        expect(@zip_path).to be_nil
        expect(File.exist?('public/collector_prepare_unpublished_spec_output.zip')).to be false
      end
    end
  end
end
