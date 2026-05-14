class CreatePages < ActiveRecord::Migration[7.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :subtitle
      t.text :teaser
      t.text :text
      t.text :footer
      t.string :slug
      t.boolean :published
      t.string :state
      t.references :map, null: false, foreign_key: true

      t.timestamps
    end
  end
end
