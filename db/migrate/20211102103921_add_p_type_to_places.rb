class AddPTypeToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :ptype, :string, default: 'info'
  end
end
