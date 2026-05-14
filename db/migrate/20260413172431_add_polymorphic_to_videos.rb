class AddPolymorphicToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :videoable_type, :string
    add_column :videos, :videoable_id, :bigint
    add_index :videos, [:videoable_type, :videoable_id]        
  end
end
