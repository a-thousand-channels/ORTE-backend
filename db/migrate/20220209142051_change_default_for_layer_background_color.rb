class ChangeDefaultForLayerBackgroundColor < ActiveRecord::Migration[5.2]
  def up
    change_column_default :layers, :background_color, ''
  end

  def down
    change_column_default :layers, :background_color, '#454545'
  end
end
