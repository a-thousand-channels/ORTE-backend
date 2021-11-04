class AddPeopleToAnnotation < ActiveRecord::Migration[5.2]
  def change
    add_column :annotations, :person_id, :integer, foreign_key: true
  end
end
