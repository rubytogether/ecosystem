class HomeController < ApplicationController
  def index
    @charts = {
      "Ruby version" => "ruby",
      "Bundler version" => "bundler",
      "RubyGems version" => "rubygems",
      # "Platform" => "platform",
      # "CI system" => "ci",
      # "TLS version" => "tls_version",
      # "Gem downloads per day" => "downloads"
    }
    @date = "2018-03-30"

    @data = @charts.map do |title, key|
      data = Stat.where(date: @date, key: key).group(:value).sum(:count)
      total_count = data.values.sum

      groups = data.group_by{|k,v| k.scan(/[^\.]+\.[^\.]+/).first }
      minors = groups.sort_by{|k,v| Gem::Version.new(k) }.map do |k,v|
        minor_count = v.map(&:last).sum
        { name: k, data: [[title, ((minor_count.to_f / total_count) * 100).round(3)]] }
      end
    end
  end

end
