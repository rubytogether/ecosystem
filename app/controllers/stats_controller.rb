class StatsController < ApplicationController
  # We need to get this data into Rickshaw series format
  def show
    data = Stat.where(key: params.fetch(:id)).pluck(:date, :value, :count)

    dates = data.map(&:first).sort.uniq
    versions = data.map(&:second).sort.uniq

    # Build a hash of hashes we can use to look up values for a specific date
    count_map = Hash.new{|h, k| h[k] = {} }
    data.each do |date, version, count|
      count_map[date][version] = count
    end

    # Build one series for each version, with an entry for every date (because
    # Rickshaw's area renderer can't handle missing points)
    #
    # [ {name: "2.2.2", data: [{x: "2018-07-13", y: 3932}, ...] }, ... ]
    series = versions.map do |version|
      points = dates.map do |date|
        {
          x: date.to_time.to_i,
          y: count_map.dig(date, version) || 0
        }
      end

      { name: version, data: points }
    end

    render json: series
  end
end
