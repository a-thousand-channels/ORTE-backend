class AddMoreSettingsToMap < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :preview_url, :string
    add_column :maps, :enable_map_to_go, :boolean, default: false
    add_column :maps, :enable_privacy_features, :boolean, default: true
    # make sure that all existing maps will not have this feature activated
    Map.update_all(enable_privacy_features: false)
  end
end
