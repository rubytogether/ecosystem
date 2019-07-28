class Stat < ApplicationRecord
  def self.week
    Arel.sql("date_trunc('week', date) as week")
  end

  def self.minor
    Arel.sql("substring(value from '\\d.\\d*') as minor")
  end

  def self.sum
    Arel.sql('sum(count) as sum')
  end

  def self.base_query(key, range)
    Stat.where('key = ? AND date > ?', key, range)
  end

  def self.weekly_data(key, range, group_minor)
    if group_minor
      base_query(key, range).group(:week, :minor).pluck(week, minor, sum)
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

  def self.daily_data(key, range, group_minor)
    if group_minor
      base_query(key, range).group(:date, :minor).pluck(:date, minor, sum)
    else
      base_query(key, range).pluck(:date, :value, :count)
    end
  end
end
