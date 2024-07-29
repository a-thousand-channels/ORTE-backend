class AddShyStateToPlace < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :shy, :boolean, default: false
  end
end
