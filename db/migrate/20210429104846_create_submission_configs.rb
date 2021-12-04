class CreateSubmissionConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :submission_configs do |t|
      t.string :title_intro
      t.string :subtitle_intro
      t.text :intro
      t.string :title_outro
      t.text :outro
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :use_city_only
      t.belongs_to :layer, foreign_key: true

      t.timestamps
    end
  end
end
