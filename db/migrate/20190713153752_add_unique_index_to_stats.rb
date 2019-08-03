class AddUniqueIndexToStats < ActiveRecord::Migration[5.2]
  def change
    add_index :stats, %i[date key value], unique: true
  end
end
