class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :title
      t.text :teaser
      t.text :text
      t.string :link
      t.datetime :startdate
      t.datetime :enddate
      t.string :lat
      t.string :lon
      t.string :location
      t.string :address
      t.string :zip
      t.string :city
      t.string :country
      t.boolean :published
      t.belongs_to :layer, foreign_key: true

      t.timestamps
    end
  end
end
