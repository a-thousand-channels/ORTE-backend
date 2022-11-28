class AddMarkerDisplayModeToMaps < ActiveRecord::Migration[6.1]
  def change
    add_column :maps, :marker_display_mode, :string, default: 'cluster'
  end
end
