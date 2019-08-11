class Stat < ApplicationRecord
  def self.weekly_data(key, range)
    if key.in?(BUCKETS.keys)
      base_query(key, range).group(:week, BUCKETS[key]).pluck(
        week,
        send(BUCKETS[key]),
        sum
      )
    else
      base_query(key, range).group(:week, :value).pluck(week, :value, sum)
    end
  end

  def self.weekly_totals(key, range)
    base_query(key, range).group(:week).pluck(week, sum).reduce(
      {}
    ) do |totals, row|
      totals[row[0]] = row[1]
      totals
    end
  end

  def self.daily_totals(key, range)
    base_query(key, range).group(:date).order(:date).sum(:count)
  end

  def self.daily_data(key, range)
    if key.in?(BUCKETS.keys)
      base_query(key, range).group(:date, BUCKETS[key]).pluck(
        :date,
        send(BUCKETS[key]),
        sum
      )
    else
      base_query(key, range).pluck(:date, :value, :count)
    end
  end

  def self.daily_comparison(key1, key2, range)
    Stat.where("(key = ? OR key = ?) AND date > ?", key1, key2, range).where
      .not(value: "")
      .group(:date, :key)
      .order(:date)
      .pluck(:date, :key, sum)
  end

  def self.weekly_comparison(key1, key2, range)
    Stat.where("(key = ? OR key = ?) AND date > ?", key1, key2, range).where
      .not(value: "")
      .group(:week, :key)
      .pluck(week, :key, sum)
  end

  private

  BUCKETS = {
    "ruby" => :minor,
    "bundler" => :minor,
    "rubygems" => :minor,
    "ci" => :ci,
    "platform" => :platform
  }

  PLATFORMS = %w[linux mingw32 darwin java]

  def self.week
    Arel.sql("date_trunc('week', date) AS week")
  end

  def self.minor
    Arel.sql("substring(value from '\\d.\\d*') AS minor")
  end

  def self.sum
    Arel.sql("sum(count) AS sum")
  end

  def self.ci
    # values for ci are a comma separated string corresponding to
    # various CI related ENV vars that are set on the source system.
    # Here, we have a somewhat ugly case statement in SQL to figure out
    # which one of the values to use
    Arel.sql(
      "CASE array_length(string_to_array(value, ','), 1)
         WHEN 1 THEN value
         WHEN 2 THEN CASE (string_to_array(value, ','))[1]
           WHEN '' THEN (string_to_array(value, ','))[2]
           WHEN 'ci' THEN (string_to_array(value, ','))[2]
           ELSE (string_to_array(value, ','))[1]
           END
         ELSE 'ci'
       END
       AS ci"
    )
  end

  def self.platform
    Arel.sql(
      "COALESCE(" +
        PLATFORMS.map { |p| "substring(value from '#{p}')" }.join(",") +
        ", 'other') AS platform"
    )
  end

  def self.base_query(key, range)
    Stat.where("key = ? AND date > ?", key, range).where.not(value: "")
  end
end
