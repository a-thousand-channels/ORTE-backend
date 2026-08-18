class CreateHyperlinks < ActiveRecord::Migration[7.2]
  def change
    create_table :hyperlinks do |t|
      t.string :url
      t.string :linktext
      t.text :note

      t.timestamps
    end
  end
end
