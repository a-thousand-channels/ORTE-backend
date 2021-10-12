class AddSlugToLayers < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :slug, :string
    add_index :layers, :slug, unique: true
  end
end
