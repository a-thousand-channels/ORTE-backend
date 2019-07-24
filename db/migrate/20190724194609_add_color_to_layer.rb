class AddColorToLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :color, :string
  end
end
