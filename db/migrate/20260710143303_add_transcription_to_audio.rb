class AddTranscriptionToAudio < ActiveRecord::Migration[7.2]
  def change
    remove_column :audios, :caption
    remove_column :audios, :alt
    add_column :audios, :transcription, :text
    add_column :audios, :subtitle, :text
  end
end
