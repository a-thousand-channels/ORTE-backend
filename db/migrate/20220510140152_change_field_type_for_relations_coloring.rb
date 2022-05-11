class ChangeFieldTypeForRelationsColoring < ActiveRecord::Migration[5.2]
  def change
    change_column :layers, :relations_coloring, :string, default: 'colored'
  end
end
