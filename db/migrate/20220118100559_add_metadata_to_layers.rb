class AddMetadataToLayers < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :teaser, :text
    add_column :layers, :style, :text
    add_column :layers, :basemap_url, :text
    add_column :layers, :basemap_attribution, :text
    add_column :layers, :tooltip_display_mode, :string, default: 'shy'
    add_column :layers, :places_sort_order, :string
  end
end
