class AddForeignKeysToAnnotationsAndPeople < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :annotations, :places
    add_foreign_key :annotations, :people
  end
end
