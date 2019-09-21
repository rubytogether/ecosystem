class ComparisonController < ApplicationController
  def show
    key1 = params.fetch(:key1)
    key2 = params.fetch(:key2)
    @range = DateRange.new(params)

    data = Stat.send(@range.prefix + "comparison", key1, key2, @range.value)

    dates = data.map(&:first).sort.uniq
    count_map = Hash.new { |h, k| h[k] = {} }
    data.each { |date, key, count| count_map[date][key] = count }

    key1_points =
      dates.map do |date|
        count = count_map.dig(date, key1) - count_map.dig(date, key2)
        y = count.to_f / count_map.dig(date, key1) * 100
        { x: date.strftime("%m/%d"), y: y }
      end

    # TODO: Make this more general
    key1_name = key1 == "bundler" && key2 == "ci" ? "Non-CI" : key1
    key1_series = { name: key1_name, data: key1_points }

    key2_points =
      dates.map do |date|
        count = count_map.dig(date, key2)
        y = count.to_f / count_map.dig(date, key1) * 100
        { x: date.strftime("%m/%d"), y: y }
      end

    key2_name = key2 == "ci" ? "CI" : key2
    key2_series = { name: key2_name, data: key2_points }

    @series = [key1_series, key2_series]

    @ranges_container_selector = ".comparison-#{key1}-#{key2}-graph-ranges"

    respond_to do |format|
      format.json { render json: @series }
      format.js { render "versions/show" }
    end
  end
end
