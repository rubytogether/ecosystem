class HomeController < ApplicationController
  def index
    return render plain: "No data!" if Stat.count.zero?

    @version_charts = {
      "Ruby" => "/versions/ruby",
      "Bundler" => "/versions/bundler",
      "RubyGems" => "/versions/rubygems",
      "Platform" => "/versions/platform",
      "CI Provider" => "/versions/ci"
    }

    @comparison_charts = {
      "Rubygems vs Bundler" => "/comparison/rubygems/bundler",
      "CI vs non-CI" => "/comparison/bundler/ci"
    }
  end
end
