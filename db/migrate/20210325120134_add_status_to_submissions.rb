class AddStatusToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :status, :integer, null: false, default: 0
  end
end
