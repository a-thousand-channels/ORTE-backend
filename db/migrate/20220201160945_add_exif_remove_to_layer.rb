class AddExifRemoveToLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :exif_remove, :boolean, default: true
  end
end
