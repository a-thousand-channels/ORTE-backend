class AddLocalesToSubmissionConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :submission_configs, :locales, :string
  end
end
