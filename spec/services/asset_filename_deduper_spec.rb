# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetFilenameDeduper do
  subject(:deduper) { described_class.new }

  it 'returns the original filename the first time it is seen' do
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo.jpg')
  end

  it 'suffixes repeated filenames in call order' do
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo.jpg')
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo-1.jpg')
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo-2.jpg')
  end

  it 'tracks collisions independently per filename' do
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo.jpg')
    expect(deduper.unique_name_for('audio.mp3')).to eq('audio.mp3')
    expect(deduper.unique_name_for('photo.jpg')).to eq('photo-1.jpg')
    expect(deduper.unique_name_for('audio.mp3')).to eq('audio-1.mp3')
  end

  it 'preserves the extension when suffixing' do
    expect(deduper.unique_name_for('archive.tar.gz')).to eq('archive.tar.gz')
    expect(deduper.unique_name_for('archive.tar.gz')).to eq('archive.tar-1.gz')
  end

  it 'does not carry state across separate instances' do
    described_class.new.unique_name_for('photo.jpg')
    expect(described_class.new.unique_name_for('photo.jpg')).to eq('photo.jpg')
  end
end
