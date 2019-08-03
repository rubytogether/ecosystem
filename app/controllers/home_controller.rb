class HomeController < ApplicationController
  def index
    return render plain: 'No data!' if Stat.count.zero?

    @charts = {
      'Ruby version' => 'ruby',
      'Bundler version' => 'bundler',
      'RubyGems version' => 'rubygems',
      'Platform' => 'platform',
      'CI system' => 'ci',
      'TLS ciphers' => 'tls_cipher'
    }
  end
end
