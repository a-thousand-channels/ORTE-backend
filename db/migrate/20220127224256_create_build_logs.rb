class CreateBuildLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :build_logs do |t|
      t.references :map, foreign_key: true
      t.references :layer, foreign_key: true
      t.string :output
      t.string :size
      t.string :version

      t.timestamps
    end
  end
end
