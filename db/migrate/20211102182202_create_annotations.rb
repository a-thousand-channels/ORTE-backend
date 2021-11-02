class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.string :title
      t.text :text
      t.belongs_to :place, foreign_key: true
      t.boolean :published, default: "false"
      t.integer :sorting
      t.text :source

      t.timestamps
    end
  end
end
