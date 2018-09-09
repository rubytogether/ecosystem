class CreateParsedLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :parsed_logs, id: :uuid do |t|
      t.string :filename, unique: true
      t.timestamp :parsed_at
      t.timestamps
    end
  end
end
