class AddCornersToMap < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :northeast_corner, :string
    add_column :maps, :southwest_corner, :string
  end
end
