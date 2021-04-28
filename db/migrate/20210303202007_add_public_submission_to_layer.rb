class AddPublicSubmissionToLayer < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :public_submission, :boolean
  end
end
