class AddImageMetadataToLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :image_alt, :text
    add_column :layers, :image_licence, :string
    add_column :layers, :image_source, :text
    add_column :layers, :image_creator, :string
    add_column :layers, :image_caption, :string
  end
end
