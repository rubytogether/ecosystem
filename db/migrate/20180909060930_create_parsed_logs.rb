class CreateParsedLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :parsed_logs, id: :uuid do |t|
      t.string :filename, unique: true, null: false
      t.timestamp :parsed_at, null: false
      t.timestamps
    end
  end
end
