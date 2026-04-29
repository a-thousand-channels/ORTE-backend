class AddPrivacyAndLanguageSettingsToMap < ActiveRecord::Migration[7.2]
  def change
    add_column :maps, "exif_remove", :boolean, default: true
    add_column :maps, "rasterize_images", :boolean, default: false
    add_column :maps, "primary_language", :string
    add_column :maps, "available_languages", :string
  end
end