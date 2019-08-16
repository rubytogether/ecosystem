class HomeController < ApplicationController
  def index
    return render plain: "No data!" if Stat.count.zero?

    @version_charts = {
      "Ruby" => "/versions/ruby",
      "Bundler version" => "/versions/bundler",
      "RubyGems version" => "/versions/rubygems",
      "Platform" => "/versions/platform",
      "CI system" => "/versions/ci",
      "TLS ciphers" => "/versions/tls_cipher"
    }

    @comparison_charts = {
      "Rubygems vs Bundler" => "/comparison/rubygems/bundler",
      "CI vs non-CI" => "/comparison/bundler/ci"
    }
  end
end
