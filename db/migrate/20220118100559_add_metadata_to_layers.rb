class AddMetadataToLayers < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :teaser, :text
    add_column :layers, :style, :text
    add_column :layers, :basemap_url, :text
    add_column :layers, :basemap_attribution, :text
    add_column :layers, :tooltip_display_mode, :string, default: 'false'
    add_column :layers, :popup_display_mode, :string, default: 'click'

  end
end
