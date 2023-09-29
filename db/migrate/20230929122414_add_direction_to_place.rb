class AddDirectionToPlace < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :direction, :string
  end
end
