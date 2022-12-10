class AddSubtitleToPlace < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :subtitle, :string
  end
end
