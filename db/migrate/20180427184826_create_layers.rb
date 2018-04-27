class CreateLayers < ActiveRecord::Migration[5.2]
  def change
    create_table :layers do |t|
      t.string :title
      t.string :text
      t.boolean :published
      t.belongs_to :map, foreign_key: true

      t.timestamps
    end
  end
end
