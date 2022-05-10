class AddRelationsOptionsToLayers < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :relations_bending, :integer, default: 1
    add_column :layers, :relations_coloring, :text, default: 'colored'
  end
end
