# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesHelper, type: :helper do
  describe 'image_url' do
    it 'it returns an polymorphic image link' do
      i = Image.new
      i.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jepg')
      expect(helper.image_url(i.file)).to eq(polymorphic_url(i.file.variant(resize: '800x800').processed).to_s)
    end
  end
  describe 'image_linktag' do
    it 'it returns an image link tag' do
      i = Image.new
      i.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(helper.image_linktag(i.file)).to eq("<img src=\"#{polymorphic_url(i.file.variant(resize: '800x800').processed)}\" title=\"\">")
    end
  end
end
