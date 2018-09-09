class CreateKeysEnum < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE stats_key AS ENUM (
        'bundler',
        'ci',
        'gemstash',
        'platform',
        'ruby',
        'rubygems',
        'server_region',
        'tls_cipher'
      );
    SQL

    remove_column :stats, :key
    add_column :stats, :key, :stats_key
  end
end
