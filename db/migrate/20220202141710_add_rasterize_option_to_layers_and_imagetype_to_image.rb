class AddRasterizeOptionToLayersAndImagetypeToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :rasterize_images, :boolean, default: false
    add_column :images, :itype, :string, default: 'image'
  end
end
