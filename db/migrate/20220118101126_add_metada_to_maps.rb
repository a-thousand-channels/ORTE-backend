class AddMetadaToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :teaser, :text
    add_column :maps, :style, :text
    add_column :maps, :color, :string
    add_column :maps, :mapcenter_lat, :string
    add_column :maps, :mapcenter_lon, :string
    add_column :maps, :zoom, :integer, default: 12
    add_column :maps, :tooltip_display_mode, :string, default: 'false'
  end
end
