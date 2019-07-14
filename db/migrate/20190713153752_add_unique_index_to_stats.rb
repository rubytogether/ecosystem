class AddUniqueIndexToStats < ActiveRecord::Migration[5.2]
  def change
    add_index :stats, [:date, :key, :value], unique: true
  end
end
