class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :name
      t.string :email
      t.boolean :rights
      t.boolean :privacy
      t.string :locale
      t.belongs_to :place, foreign_key: true  

      t.timestamps
    end
  end
end
