class ChangeDefaultForTooltip < ActiveRecord::Migration[5.2]
  def up
    change_column_default :maps, :tooltip_display_mode, 'none'
    change_column_default :layers, :tooltip_display_mode, 'none'
  end

  def down
    change_column_default :maps, :tooltip_display_mode, 'shy'
    change_column_default :layers, :tooltip_display_mode, 'shy'
  end
end
