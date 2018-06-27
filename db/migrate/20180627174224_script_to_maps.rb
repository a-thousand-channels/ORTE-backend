class ScriptToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :script, :text
  end
end
