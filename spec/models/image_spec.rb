# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  include Rails.application.routes.url_helpers

  it 'has a valid factory' do
    expect(build(:image)).to be_valid
  end

  it 'has an image type' do
    m = FactoryBot.create(:map)
    l = FactoryBot.create(:layer, map: m)
    l.exif_remove = true
    p = FactoryBot.create(:place, layer: l)
    i = create(:image, place: p)
    expect(i.itype).to eq('image')
  end

  describe 'Attachment' do
    it 'is valid' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.file).to be_attached
    end
  end

  describe 'Image links and tags' do
    it 'image_filename' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_filename).to eq(subject.file.filename)
    end
    it 'image_url' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_url).to eq("http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.file.variant(resize: '800x800').processed))}")
    end
    it 'image_path' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_path).to eq(Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.file.variant(resize: '800x800').processed)))
    end
    it 'image_linktag' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.image_linktag).to eq("<img src=\"http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.file.variant(resize: '800x800').processed))}\" title=\"\">")
    end
    it 'image_on_disk' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      variant = subject.file.variant(resize: '1200x1200').processed
      full_path = ActiveStorage::Blob.service.path_for(variant.key)
      expect(subject.image_on_disk).to eq(full_path.gsub(Rails.root.to_s, ''))
    end
  end

  describe 'EXIF' do
    it 'should read EXIF data' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.get_exif_data).to eq({})
    end

    it 'should remove EXIF data' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, map: m)
      l.exif_remove = true
      p = FactoryBot.create(:place, layer: l)
      i = create(:image, place: p)
      i.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      i.save!
    end
  end

  describe 'Image checks and validations' do
    before do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, map: m)
      @p = FactoryBot.create(:place, layer: l)
    end
    it 'should check if title is present' do
      image = build(:image, place: @p)
      expect(image).to be_valid
      expect(image.errors).to be_empty
    end
    it 'should be invalid if no title is present' do
      image = build(:image, :notitle, place: @p)
      expect(image).not_to be_valid
      expect(image.errors[:title]).to eq(['Image description can not be blank'])
    end
    xit 'should be invalid if no file is present' do
      image = build(:image, :nofile, place: @p)
      expect(image).not_to be_valid
      expect(image.errors[:file]).to eq(['no file present'])
    end
    it 'should check_file_format' do
      image = build(:image, :nofile, place: @p)
      image.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.txt')), filename: 'attachment.txt', content_type: 'txt/plain')
      expect(image).not_to be_valid
      expect(image.errors[:file]).to eq(['File format must be JPG/PNG or GIF'])
    end
  end
end
