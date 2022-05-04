require "csv"

data_file = File.expand_path("seeds/stats.csv", __dir__)

created_at = Time.now

stats = []
CSV.foreach(data_file) { |row| stats.push([[created_at.year, *row[1..2]].join("-"), *row[3..-1]]) }
stats.shift

stat_values =
  stats.map do |s|
    s.push(created_at, created_at)
    "(" + s.map { |v| "'#{v}'" }.join(", ") + ")"
  end.join(", ")

insert =
  "INSERT INTO stats
  (date, value, count, key, created_at, updated_at)
  VALUES #{
    stat_values
  }"
Stat.connection.execute(insert) # remove header row
