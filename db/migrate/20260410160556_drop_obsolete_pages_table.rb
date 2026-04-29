
class DropObsoletePagesTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :pages, if_exists: true
  end
end
