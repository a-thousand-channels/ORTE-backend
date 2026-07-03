# frozen_string_literal: true

class MigratePlaceAudioToAudios < ActiveRecord::Migration[7.2]
  def up
    ActiveStorage::Attachment.where(name: 'audio', record_type: 'Place').find_each do |attachment|
      place = Place.find_by(id: attachment.record_id)
      next unless place

      audio = Audio.create!(
        title: place.title,
        audioable_type: 'Place',
        audioable_id: place.id,
        sorting: 1,
        preview: false,
        locale: 'de'
      )

      attachment.update_columns(
        name: 'file',
        record_type: 'Audio',
        record_id: audio.id
      )
    end
  end

  def down
    Audio.where(audioable_type: 'Place').find_each do |audio|
      attachment = ActiveStorage::Attachment.find_by(name: 'file', record_type: 'Audio', record_id: audio.id)

      if attachment
        attachment.update_columns(
          name: 'audio',
          record_type: 'Place',
          record_id: audio.audioable_id
        )
      end

      audio.destroy!
    end
  end
end
