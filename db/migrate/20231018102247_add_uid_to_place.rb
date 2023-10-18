class AddUidToPlace < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :uid, :string
  end
end
