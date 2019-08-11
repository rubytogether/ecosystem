class HomeController < ApplicationController
  def index
    return render plain: "No data!" if Stat.count.zero?

    @charts = {
      "Ruby" => "/versions/ruby",
      "Bundler version" => "/versions/bundler",
      "RubyGems version" => "/versions/rubygems",
      "Platform" => "/versions/platform",
      "CI system" => "/versions/ci",
      "TLS ciphers" => "/versions/tls_cipher",
      "Rubygems vs Bundler" => "/comparison/ruby/bundler"
    }
  end
end
