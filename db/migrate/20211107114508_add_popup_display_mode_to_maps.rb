class AddPopupDisplayModeToMaps < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :popup_display_mode, :string, default: 'click'
  end
end
