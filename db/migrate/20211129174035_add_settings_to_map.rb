class AddSettingsToMap < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :show_annotations_on_map, :boolean, default: false
  end
end
