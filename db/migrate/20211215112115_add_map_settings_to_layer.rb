class AddMapSettingsToLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :mapcenter_lat, :string
    add_column :layers, :mapcenter_lon, :string
    add_column :layers, :zoom, :integer, default: 12
  end
end
