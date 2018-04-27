class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.string :title
      t.string :text
      t.boolean :published
      t.belongs_to :group, foreign_key: true

      t.timestamps
    end
  end
end
