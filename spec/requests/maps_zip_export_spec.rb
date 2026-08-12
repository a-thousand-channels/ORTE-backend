# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps#show zip export', type: :request do
  let(:group) { FactoryBot.create(:group) }
  let(:user) { FactoryBot.create(:admin_user, group: group) }
  let(:map) { FactoryBot.create(:map, group: group, published: true) }
  let(:layer) { FactoryBot.create(:layer, map: map, published: true) }
  let(:place) { FactoryBot.create(:place, layer: layer, published: true) }

  before do
    sign_in user

    image = FactoryBot.create(:image, imageable: place)
    image.file.attach(
      io: File.open(Rails.root.join('spec/support/files/test.jpg')),
      filename: 'photo.jpg',
      content_type: 'image/jpeg'
    )
  end

  after do
    zip_file = "orte-map-#{map.title.parameterize}-#{I18n.l Date.today}.zip"
    FileUtils.rm_f(Rails.root.join('public', zip_file))
  end

  it 'downloads the ZIP at exactly the path it announces, with no double extension' do
    get map_path(map, format: :zip)

    expect(response).to have_http_status(:ok)
    expect(response.headers['Content-Type']).to eq('application/zip')

    zip_file = "orte-map-#{map.title.parameterize}-#{I18n.l Date.today}.zip"
    expect(File.exist?(Rails.root.join('public', zip_file))).to be true
    expect(File.exist?(Rails.root.join('public', "#{zip_file}.zip"))).to be false
  end
end
