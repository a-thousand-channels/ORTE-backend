# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Layer, type: :model do
  include Rails.application.routes.url_helpers

  it 'has a valid factory' do
    expect(build(:layer)).to be_valid
  end

  describe 'Layer data' do
    it 'has some image metadata' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, map: m)
      expect(l.image_alt).to eq('An alternative text')
      expect(l.image_creator).to eq('The creator of the image')
    end
  end

  describe 'Layer image' do
    describe 'Attachment' do
      it 'is valid  ' do
        subject.image.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
        expect(subject.image).to be_attached
      end
    end

    it 'image_filename' do
      subject.image.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_filename).to eq(subject.image.filename)
    end
    it 'image_link' do
      subject.image.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_link).to eq("http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.image.variant(resize: '800x800').processed))}")
    end
  end

  describe 'Layer background image' do
    describe 'Attachment' do
      it 'is valid' do
        subject.backgroundimage.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
        expect(subject.backgroundimage).to be_attached
      end
    end

    it 'backgroundimage_filename' do
      subject.backgroundimage.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.backgroundimage_filename).to eq(subject.backgroundimage.filename)
    end
    it 'backgroundimage_link' do
      subject.backgroundimage.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.backgroundimage_link).to eq("http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.backgroundimage.variant(resize: '800x800').processed))}")
    end
  end

  describe 'Layer favicon image' do
    describe 'Attachment' do
      it 'is valid' do
        subject.favicon.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
        expect(subject.favicon).to be_attached
      end
    end

    it 'favicon_filename' do
      subject.favicon.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.favicon_filename).to eq(subject.favicon.filename)
    end
    it 'favicon_link' do
      subject.favicon.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.favicon_link).to eq("http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.favicon.variant(resize: '800x800').processed))}")
    end
  end

  describe 'EXIF' do
    it 'should read EXIF data' do
      subject.image.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.get_exif_data).to eq({})
    end

    it 'should remove EXIF data' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, map: m)
      l.exif_remove = true
      l.image.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      l.save!
    end
  end

  describe 'ZIP' do
    xit 'should create a ZIP archive' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, map: m)
      p1 = FactoryBot.create(:place, layer: l)
      p2 = FactoryBot.create(:place, layer: l)
      l.reload
      puts l.places.count
      zip_file = "orte-map-#{l.map.title.parameterize}-layer-#{l.title.parameterize}-#{I18n.l Date.today}.zip"
      expect(l.to_zip(zip_file)).to eq('bla')
    end
  end
end
