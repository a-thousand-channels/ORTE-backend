# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  include Rails.application.routes.url_helpers

  it 'has a valid factory' do
    expect(build(:image)).to be_valid
  end

  describe 'Attachment' do
    it 'is valid  ' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
      expect(subject.file).to be_attached
    end
  end

  it 'image_url' do
    subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
    expect(subject.image_url).to eq("http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.file.variant(resize: '800x800').processed))}")
  end
  it 'image_linktag' do
    subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'attachment.jpg', content_type: 'image/jpeg')
    expect(subject.image_linktag).to eq("<img src=\"http://127.0.0.1:3000#{Rails.application.routes.url_helpers.url_for(polymorphic_path(subject.file.variant(resize: '800x800').processed))}\" title=\"\">")
  end
end
