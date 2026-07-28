class AddPublishedToAudiosImagesVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :audios, :published, :boolean, default: true
    add_column :images, :published, :boolean, default: true
    add_column :videos, :published, :boolean, default: true
  end
end
