class AddLocaleToAudio < ActiveRecord::Migration[7.2]
  def change
     add_column :audios, :locale, :string, null: false
  end
end
