class AddLTypeToLayers < ActiveRecord::Migration[6.1]
  def change
    add_column :layers, :ltype, :string, default: 'standard'
  end
end
