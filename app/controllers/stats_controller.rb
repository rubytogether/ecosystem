class StatsController < ApplicationController
  RANGES = {
    "1year" => Date.today - 1.year,
    "3months" => Date.today - 90.day,
    "1month" => Date.today - 30.day,
    "2weeks" => Date.today - 2.weeks
  }

  MINOR_KEYS = %w[ruby bundler rubygems]

  def show
    @key = params.fetch(:id)
    range = RANGES[params[:range] || "3months"]

    if params[:range] == "1year"
      data = Stat.weekly_data(@key, range, @key.in?(MINOR_KEYS))
      date_totals = Stat.weekly_totals(@key, range)
    else
      data = Stat.daily_data(@key, range, @key.in?(MINOR_KEYS))
      date_totals = Stat.daily_totals(@key, range)
    end

    if params[:total]
      points =
        date_totals.map { |date, count| { x: date.to_time.to_i, y: count } }

      return render json: [{ name: "total", data: points }]
    end

    dates = data.map(&:first).sort.uniq
    versions = data.map(&:second).sort.uniq

    # Build a hash of hashes we can use to look up values for a specific date
    count_map = Hash.new { |h, k| h[k] = {} }
    data.each { |date, version, count| count_map[date][version] = count }

    # Build one series for each version, with an entry for every date
    #
    # [ {name: "2.2.2", data: [{x: "2018-07-13", y: 3932}, ...] }, ... ]
    top5 = versions.max_by(10) { |v| count_map[count_map.keys.last][v] || 0 }

    top5_series =
      top5.map do |version|
        points =
          dates.map do |date|
            count = count_map.dig(date, version) || 0
            y = (count.to_f / date_totals[date]) * 100
            { x: date.strftime("%m/%d/%y"), y: y }
          end

        { name: "#{@key} #{version}", data: points }
      end

    the_rest = {
      name: "Others",
      data:
        dates.map do |date|
          count = count_map[date].reject { |v| v.in?(top5) }.sum { |_, c| c }
          y = (count.to_f / date_totals[date]) * 100
          # TODO: Move the formatting to JS
          { x: date.strftime("%m/%d/%y"), y: y }
        end
    }

    @series = top5_series.push(the_rest)
    return render action: :show if params[:range]

    render json: @series
  end
end
