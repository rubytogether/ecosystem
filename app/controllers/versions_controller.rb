class VersionsController < ApplicationController
  def show
    key = params.fetch(:key)
    @range = DateRange.new(params)

    data = Stat.send(@range.prefix + "data", key, @range.value)
    date_totals = Stat.send(@range.prefix + "totals", key, @range.value)

    if params[:total]
      points =
        date_totals.map do |date, count|
          { x: date.strftime("%m/%d"), y: count }
        end
      @series = [{ name: "total", data: points }]
      @total = true
      @ranges_container_selector = ".ruby-total-ranges"
    else
      dates = data.map(&:first).sort.uniq
      count_map = count(data)

      # Build one series for each version, with an entry for every date
      #
      # [ {name: "2.2.2", data: [{x: "2018-07-13", y: 3932}, ...] }, ... ]
      versions = count_map.values.flat_map(&:keys).compact.sort.uniq
      top =
        versions.max_by(MAXES[key]) do |v|
          count_map[count_map.keys.last][v] || 0
        end

      top_series =
        top.map do |version|
          points =
            dates.map do |date|
              count = count_map.dig(date, version) || 0
              y = (count.to_f / date_totals[date]) * 100
              { x: date.strftime("%m/%d"), y: y }
            end

          { name: "#{version}", data: points }
        end

      if top.length < versions.length
        the_rest = {
          name: "Others",
          data:
            dates.map do |date|
              count = count_map[date].reject { |v| v.in?(top) }.sum { |v, c| c }
              y = (count.to_f / date_totals[date]) * 100
              # TODO: Move the formatting to JS
              { x: date.strftime("%m/%d"), y: y }
            end
        }
      end

      @series = the_rest ? top_series.push(the_rest) : top_series
      @ranges_container_selector = ".versions-#{key}-graph-ranges"
    end

    respond_to do |format|
      format.json { render json: @series }
      format.js
    end
  end

  private

  MAXES = { "platform" => 3 }
  MAXES.default = 5

  def count(data)
    # Build a hash of hashes we can use to look up values for a specific date
    count_map = Hash.new { |h, k| h[k] = {} }
    data.each { |date, version, count| count_map[date][version] = count }
    count_map
  end
end
