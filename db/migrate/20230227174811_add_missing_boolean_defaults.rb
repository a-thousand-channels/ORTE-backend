class AddMissingBooleanDefaults < ActiveRecord::Migration[6.1]
  def change
    change_column :maps, :published, :boolean, :default => false
    change_column :layers, :published, :boolean, :default => false
    change_column :layers, :public_submission, :boolean, :default => false
    change_column :places, :published, :boolean, :default => false
    change_column :places, :featured, :boolean, :default => false
  end
end
