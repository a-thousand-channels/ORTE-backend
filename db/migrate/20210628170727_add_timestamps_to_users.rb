class AddTimestampsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :users, default: Time.zone.now
  end
end
