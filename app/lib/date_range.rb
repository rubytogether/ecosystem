class DateRange
  RANGES = {
    "1year" => Date.today - 1.year,
    "3months" => Date.today - 90.days,
    "1month" => Date.today - 30.days,
    "2weeks" => Date.today - 2.weeks
  }

  RANGES.default = Date.today - 90.days

  attr_reader :value

  def initialize(params)
    @value = RANGES[params[:range]]
  end

  def prefix
    @value > RANGES["1year"] ? "daily_" : "weekly_"
  end
end
