# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Map, type: :model do
  it 'has a valid factory' do
    expect(build(:map)).to be_valid
  end

  describe '#to_zip' do
    let(:map) { FactoryBot.create(:map, published: true) }
    let(:layer) { FactoryBot.create(:layer, map: map, published: true) }
    let(:place) { FactoryBot.create(:place, layer: layer, published: true) }
    # callers (e.g. MapsController#show) build the full filename themselves, extension included
    let(:zip_filename) { "orte-map-#{map.friendly_id}-export.zip" }

    def attach_jpg(record, filename)
      record.file.attach(
        io: File.open(Rails.root.join('spec/support/files/test.jpg')),
        filename: filename,
        content_type: 'image/jpeg'
      )
    end

    before do
      # two place images and one page image intentionally share a filename,
      # to exercise the per-map dedupe path
      image1 = FactoryBot.create(:image, imageable: place)
      attach_jpg(image1, 'photo.jpg')

      image2 = FactoryBot.create(:image, imageable: place)
      attach_jpg(image2, 'photo.jpg')

      audio = FactoryBot.create(:audio, audioable: place, locale: 'en')
      audio.file.attach(
        io: File.open(Rails.root.join('spec/support/files/test.mp3')),
        filename: 'sound.mp3',
        content_type: 'audio/mpeg'
      )

      page = FactoryBot.create(:page, pageable: place, published: true)
      page_image = FactoryBot.create(:image, imageable: page)
      attach_jpg(page_image, 'photo.jpg')
    end

    after { FileUtils.rm_f(@zip_path) }

    it 'creates a ZIP archive at exactly the path the caller asked for, and cleans up the tmp folder' do
      @zip_path = map.to_zip(zip_filename)

      expect(@zip_path).to eq("public/#{zip_filename}")
      expect(File.exist?(@zip_path)).to be true
      expect(Dir.glob('tmp/*_assets')).to be_empty
    end

    it 'includes the map JSON and every published asset, deduping colliding filenames' do
      @zip_path = map.to_zip(zip_filename)

      entries = Zip::File.open(@zip_path) { |zip| zip.map(&:name) }

      expect(entries).to contain_exactly(
        "#{map.friendly_id}.json", 'photo.jpg', 'photo-1.jpg', 'photo-2.jpg', 'sound.mp3'
      )
    end

    it 'keeps the exported JSON filenames in sync with the deduped names in the archive' do
      @zip_path = map.to_zip(zip_filename)

      json = Zip::File.open(@zip_path) { |zip| JSON.parse(zip.read("#{map.friendly_id}.json"), symbolize_names: true) }
      place_json = json[:map][:layer].flat_map { |l| l[:places] }.first
      filenames = place_json[:images].map { |i| i[:image_filename] }

      expect(filenames.sort).to eq(%w[photo-1.jpg photo.jpg])
    end

    context 'when a place is unpublished' do
      it 'excludes its assets from the archive' do
        place.update!(published: false)

        @zip_path = map.to_zip(zip_filename)
        entries = Zip::File.open(@zip_path) { |zip| zip.map(&:name) }

        expect(entries).to eq(["#{map.friendly_id}.json"])
      end
    end
  end
end
