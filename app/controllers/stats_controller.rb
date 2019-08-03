class StatsController < ApplicationController
  # We need to get this data into Rickshaw series format
  def show
    base_query =
      Stat.where("key = ? AND date > ?", params.fetch(:id), Date.today - 60.day)
    date_totals = base_query.group(:date).order(:date).sum(:count)

    if params[:total]
      points =
        date_totals.map { |date, count| { x: date.to_time.to_i, y: count } }

      return render json: [{ name: "total", data: points }]
    end

    data = base_query.pluck(:date, :value, :count)

    dates = data.map(&:first).sort.uniq
    versions = data.map(&:second).sort.uniq

    # Build a hash of hashes we can use to look up values for a specific date
    count_map = Hash.new { |h, k| h[k] = {} }
    data.each { |date, version, count| count_map[date][version] = count }

    # Build one series for each version, with an entry for every date (because
    # Rickshaw's area renderer can't handle missing points)
    #
    # [ {name: "2.2.2", data: [{x: "2018-07-13", y: 3932}, ...] }, ... ]
    series =
      versions.map do |version|
        points =
          dates.map do |date|
            count = count_map.dig(date, version) || 0
            y = (count.to_f / date_totals[date]) * 100
            { x: date.to_time.to_i, y: y }
          end

        { name: "#{params[:id]} #{version}", data: points }
      end

    render json: series
  end
end
