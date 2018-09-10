class HomeController < ApplicationController
  def index
    @charts = {
      "Ruby version" => "ruby",
      # "Bundler version" => "bundler",
      # "RubyGems version" => "rubygems",
      # "Platform" => "platform",
      # "CI system" => "ci",
      # "TLS ciphers" => "tls_ciphers"
    }

    @latest = Stat.order(:date).first.date
  end

end
