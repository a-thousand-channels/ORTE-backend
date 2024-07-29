# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Annotation, type: :model do
  it 'has a valid factory' do
    expect(build(:annotation)).to be_valid
  end

  describe 'Audio attachment' do
    it 'is attached' do
      subject.audio.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
      expect(subject.audio).to be_attached
    end
    it 'is invalid ' do
      subject.audio.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.m4a')), filename: 'test.mp3', content_type: 'audio/mpeg')
      # expect(subject.audio).not_to be_attached
      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to include('Audio format must be MP3.')
    end
  end

  describe 'dynamic fields' do
    it 'person_name' do
      m = FactoryBot.create(:map)
      p = FactoryBot.create(:person, map: m)
      a = FactoryBot.create(:annotation, person: p)
      expect(a.person_name).to eq(p.name)
    end
    it 'audiolink' do
      m = FactoryBot.create(:map)
      p = FactoryBot.create(:person, map: m)
      a = FactoryBot.create(:annotation, person: p)
      a.audio.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'test.mp3')), filename: 'test.mp3', content_type: 'audio/mpeg')
      expect(a.audiolink).to eq("<audio controls=\"controls\" src=\"#{Rails.application.routes.url_helpers.url_for(a.audio)}\"></audio>")
    end
  end
end
