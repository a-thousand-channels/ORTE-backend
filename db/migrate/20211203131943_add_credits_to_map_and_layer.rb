class AddCreditsToMapAndLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :credits, :text
    add_column :layers, :credits, :text
  end
end
