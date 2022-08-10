class AddUseBackgroundFromParentMap < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :use_background_from_parent_map, :boolean, default: true
  end
end
