class AddPlaceToHyperlinks < ActiveRecord::Migration[7.2]
  def change
    add_reference :hyperlinks, :place, null: false, foreign_key: true
  end
end
