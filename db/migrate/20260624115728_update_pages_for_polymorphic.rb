class UpdatePagesForPolymorphic < ActiveRecord::Migration[7.2]
  def change
    remove_column :pages, :map_id
    add_column :pages, :pageable_id, :bigint
    add_column :pages, :pageable_type, :string
    add_index :pages, [:pageable_id, :pageable_type]
  end    
end
