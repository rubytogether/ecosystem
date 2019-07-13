class AddTimestampsToStats < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :stats, null: true
  end
end
