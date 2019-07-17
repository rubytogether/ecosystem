class HomeController < ApplicationController
  def index
    if Stat.count.zero?
      return render plain: "No data!"
    end

    @charts = {
      "Ruby version" => "ruby",
      "Bundler version" => "bundler",
      "RubyGems version" => "rubygems",
      "Platform" => "platform",
      "CI system" => "ci",
      "TLS ciphers" => "tls_cipher"
    }
  end
end
