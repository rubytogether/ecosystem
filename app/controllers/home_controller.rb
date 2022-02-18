class HomeController < ApplicationController
  def index
    return render plain: "No data!" if Stat.count.zero?

    suffix = params[:unique] ? "_unique" : ""

    @version_charts = {
      "Ruby" => "/versions/ruby#{suffix}",
      "Bundler" => "/versions/bundler#{suffix}",
      "RubyGems" => "/versions/rubygems#{suffix}",
      "Platform" => "/versions/platform#{suffix}",
      "CI Provider" => "/versions/ci#{suffix}"
    }

    @comparison_charts = {
      "Rubygems vs Bundler" => "/comparison/rubygems#{suffix}/bundler#{suffix}",
      "CI vs non-CI" => "/comparison/bundler#{suffix}/ci#{suffix}"
    }
  end
end
