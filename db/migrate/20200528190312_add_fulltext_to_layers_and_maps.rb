class AddFulltextToLayersAndMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :text, :text
    add_column :layers, :text, :text    
  end
end
