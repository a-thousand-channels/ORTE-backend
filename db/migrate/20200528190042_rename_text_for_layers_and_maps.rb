class RenameTextForLayersAndMaps < ActiveRecord::Migration[5.2]
 def change
    rename_column :layers, :text, :subtitle
    rename_column :maps, :text, :subtitle
  end
end
