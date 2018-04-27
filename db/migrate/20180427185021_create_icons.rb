class CreateIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :icons do |t|
      t.string :title
      t.string :image
      t.belongs_to :iconset, foreign_key: true

      t.timestamps
    end
  end
end
