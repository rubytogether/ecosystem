require "csv"

data_file = File.expand_path("seeds/stats.csv", __dir__)

stats = []
CSV.foreach(data_file) do |row|
  stats.push([row[0..2].join("-"), *row[3..-1]])
end
stats.shift # remove header row

created_at = Time.now
stat_values = stats.map do |s|
  s.push(created_at, created_at)
  "(" + s.map{|v| "'#{v}'" }.join(", ") + ")"
end.join(", ")

insert = "INSERT INTO stats
  (date, value, count, key, created_at, updated_at)
  VALUES #{stat_values}"
Stat.connection.execute(insert)
