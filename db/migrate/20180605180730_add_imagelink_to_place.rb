class AddImagelinkToPlace < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :imagelink, :string
  end
end
