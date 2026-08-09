# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Map export', type: :request do
  let(:map) { FactoryBot.create(:map, published: true) }
  let(:layer) { FactoryBot.create(:layer, map: map, published: true) }
  let(:place) { FactoryBot.create(:place, layer: layer, published: true) }

  before do
    host! '127.0.0.1:3000'

    image = FactoryBot.create(:image, imageable: place)
    image.file.attach(
      io: File.open(Rails.root.join('spec/support/files/test.jpg')),
      filename: 'photo.jpg',
      content_type: 'image/jpeg'
    )
  end

  it 'matches the JSON served by the public map endpoint' do
    get public_map_path(map), params: { format: :json }
    from_endpoint = JSON.parse(response.body, symbolize_names: true)

    from_export, = MapAssetsCollector.new(map).generate_map_json

    expect(from_export).to eq(from_endpoint)
  end

  it 'matches the JSON packaged inside the ZIP export' do
    get public_map_path(map), params: { format: :json }
    from_endpoint = JSON.parse(response.body, symbolize_names: true)

    zip_path = map.to_zip("#{map.friendly_id}-export.zip")
    from_zip = Zip::File.open(zip_path) { |zip| JSON.parse(zip.read("#{map.friendly_id}.json"), symbolize_names: true) }
    FileUtils.rm_f(zip_path)

    expect(from_zip).to eq(from_endpoint)
  end

  context 'when a layer has no published places' do
    it 'the endpoint response and the export still agree' do
      other_layer = FactoryBot.create(:layer, map: map, published: true)
      FactoryBot.create(:place, layer: other_layer, published: false)

      get public_map_path(map), params: { format: :json }
      from_endpoint = JSON.parse(response.body, symbolize_names: true)

      from_export, = MapAssetsCollector.new(map).generate_map_json

      expect(from_export).to eq(from_endpoint)
    end
  end
end
