class AddPeopleToMap < ActiveRecord::Migration[5.2]
  def change
    remove_reference :maps, :person, foreign_key: true # make last migration undo
    add_reference :people, :map, foreign_key: true
  end
end
