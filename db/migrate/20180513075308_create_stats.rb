class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats, id: :uuid do |t|
      t.date :date, null: false
      t.string :key, null: false
      t.string :value, null: false
      t.integer :count, null: false, default: 0
    end
  end
end
