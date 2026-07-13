# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audio, type: :model do
  let(:audio) { create(:audio) }

  it 'has a valid factory' do
    expect(audio).to be_valid
  end

  describe 'Attachment' do
    it 'is valid' do
      audio.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
      audio.save!
      expect(audio.file).to be_attached
    end
  end

  it 'audio_url' do
    audio.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
    expect(audio.audio_url).to eq(Rails.application.routes.url_helpers.url_for(audio.file))
  end

  it 'audio_linktag' do
    audio.file.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
    expect(audio.audio_linktag).to eq("<audio controls=\"controls\" preload=\"metadata\" src=\"#{Rails.application.routes.url_helpers.url_for(audio.file)}\"></audio>")
  end
end
