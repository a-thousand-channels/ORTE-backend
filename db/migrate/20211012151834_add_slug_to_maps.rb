class AddSlugToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :slug, :string
    add_index :maps, :slug, unique: true
  end
end
