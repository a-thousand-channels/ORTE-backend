class AddMapToPeople < ActiveRecord::Migration[5.2]
  def change
    add_reference :maps, :person, foreign_key: true
  end
end
