class AddUseMapcenterFromParentMap < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :use_mapcenter_from_parent_map, :boolean, default: true
  end
end
