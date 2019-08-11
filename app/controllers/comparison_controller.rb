class ComparisonController < ApplicationController
  def show
    key1 = params.fetch(:key1)
    key2 = params.fetch(:key2)
    # TODO: extract range processing out - this is duplicated in VersionsController
    range = RANGES[params[:range] || "3months"]

    range_prefix = params[:range] === "1year" ? "weekly_" : "daily_"

    data = Stat.send(range_prefix + "comparison", key1, key2, range)

    dates = data.map(&:first).sort.uniq
    count_map = Hash.new { |h, k| h[k] = {} }
    data.each { |date, key, count| count_map[date][key] = count }

    key1_points =
      dates.map do |date|
        count = count_map.dig(date, key1) - count_map.dig(date, key2)
        y = count.to_f / count_map.dig(date, key1) * 100
        { x: date.strftime("%m/%d"), y: y }
      end

    key1_series = { name: key1, data: key1_points }

    key2_points =
      dates.map do |date|
        count = count_map.dig(date, key2)
        y = count.to_f / count_map.dig(date, key1) * 100
        { x: date.strftime("%m/%d"), y: y }
      end

    key2_series = { name: key2, data: key2_points }

    @series = [key1_series, key2_series]

    respond_to do |format|
      format.json { render json: @series }
      format.js { render "versions/show" }
    end
  end

  private

  RANGES = {
    "1year" => Date.today - 1.year,
    "3months" => Date.today - 90.days,
    "1month" => Date.today - 30.days,
    "2weeks" => Date.today - 2.weeks
  }
  RANGES.default = Date.today - 90.days
end
