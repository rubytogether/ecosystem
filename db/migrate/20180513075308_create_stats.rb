class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats, id: :uuid do |t|
      t.date :date
      t.string :key
      t.string :value
      t.integer :count

      t.timestamps
    end
  end
end
