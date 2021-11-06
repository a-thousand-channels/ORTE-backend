class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.string :title
      t.text :text
      t.bigint :place_id
      t.bigint :person_id
      t.boolean :published, default: "false"
      t.integer :sorting
      t.text :source

      t.timestamps
    end
  end
end
