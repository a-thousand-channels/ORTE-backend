class AddSensitiveToPlace < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :sensitive, :boolean, default: false
    add_column :places, :sensitive_radius, :integer, default: 100
  end
end
