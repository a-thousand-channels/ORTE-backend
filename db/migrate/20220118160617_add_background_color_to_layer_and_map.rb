class AddBackgroundColorToLayerAndMap < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :background_color, :string, default: '#454545'
    add_column :layers, :background_color, :string, default: '#454545'
  end
end
