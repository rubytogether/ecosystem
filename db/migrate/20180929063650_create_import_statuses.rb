class CreateImportStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :import_statuses, id: :uuid do |t|
      t.string :key, unique: true, null: false
      t.date :date, null: false
      t.timestamp :imported_at
      t.jsonb :data
      t.timestamps

      t.index :key
    end
  end
end
