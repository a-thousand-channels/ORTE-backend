# frozen_string_literal: true

class CreateAudios < ActiveRecord::Migration[7.2]
  def change
    create_table :audios do |t|
      t.string :title
      t.string :licence
      t.text :source
      t.string :creator
      t.string :alt
      t.string :caption
      t.integer :sorting
      t.boolean :preview
      t.string :audioable_type
      t.bigint :audioable_id
      t.string :locale

      t.timestamps
    end

    add_index :audios, [:audioable_type, :audioable_id]
  end
end
