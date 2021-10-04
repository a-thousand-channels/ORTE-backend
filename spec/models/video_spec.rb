# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  it 'has a valid factory' do
    expect(build(:video)).to be_valid
  end

  describe 'Attachment' do
    it 'is valid' do
      subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp4')), filename: 'attachment.mp4', content_type: 'video/mp4')
      expect(subject.file).to be_attached
    end
  end

  it 'video_url' do
    subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp4')), filename: 'attachment.jpg', content_type: 'video/mp4')
    expect(subject.video_url).to eq(Rails.application.routes.url_helpers.url_for(subject.file))
  end
  it 'video_linktag' do
    subject.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp4')), filename: 'attachment.jpg', content_type: 'video/mp4')
    subject.filmstill.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.jpg')), filename: 'filmstill.jpg', content_type: 'image/jepg')
    expect(subject.video_linktag).to eq("<video controls=\"controls\" preload=\"metadata\" poster=\"#{Rails.application.routes.url_helpers.url_for(subject.filmstill)}\" src=\"#{Rails.application.routes.url_helpers.url_for(subject.file)}\"></video>")
  end
end
