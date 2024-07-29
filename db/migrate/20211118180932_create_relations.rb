class CreateRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :relations do |t|
      t.integer :relation_from_id
      t.integer :relation_to_id
      t.string :rtype

      t.timestamps
    end
  end
end
