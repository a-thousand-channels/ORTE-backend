class AddPolymorphicToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :imageable_type, :string
    add_column :images, :imageable_id, :bigint
    add_index :images, [:imageable_type, :imageable_id]    
  end
end
