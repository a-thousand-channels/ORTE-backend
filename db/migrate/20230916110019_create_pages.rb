class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.boolean :is_published, default: false
      t.boolean :in_menu, default: false
      t.string :ptype
      t.string :title
      t.text :teasertext
      t.text :fulltext
      t.text :footertext

      t.timestamps
    end
  end
end
