class CreateStringTranslations < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :mobility_string_translations
      create_table :mobility_string_translations do |t|
        t.string :locale, null: false
        t.string :key, null: false
        t.string :value
        t.references :translatable, polymorphic: true, index: false
        t.timestamps null: false
      end
    end
    add_index :mobility_string_translations, [:translatable_id, :translatable_type, :locale, :key], unique: true, name: :index_mobility_string_translations_on_keys
    add_index :mobility_string_translations, [:translatable_id, :translatable_type, :key], name: :index_mobility_string_translate_translatable_attribute
    add_index :mobility_string_translations, [:translatable_type, :key, :value, :locale], name: :index_mobility_string_translate_query_keys
  end
end
