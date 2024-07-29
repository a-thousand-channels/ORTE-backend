class AddStatusAndMessageToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :active, :boolean, default: true
    add_column :groups, :message, :text
  end
end
