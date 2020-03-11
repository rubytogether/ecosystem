source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby Pathname.new(".ruby-version").expand_path(__dir__).read

gem "rails", "~> 5.2.3"

gem "aws-sdk-s3", "~> 1.46"
gem "bootsnap", ">= 1.1.0", require: false
gem "bulk_insert", git: "https://github.com/jamis/bulk_insert.git"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "sidekiq", "~> 5.2"
gem "webpacker", "~> 4.0"
gem "apexcharts"

# Gems in both rubygems.org and gems.contribsys.com
gem "redis"
gem "connection_pool"
gem "rack-protection"
gem "concurrent-ruby"
gem "rack"

group :development, :test do
  gem "pry-byebug", require: false
  gem "pry-rails", "~> 0.3.9"
  gem "rspec-rails", "~> 3.9"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
end

source "https://gems.contribsys.com/" do
  gem "sidekiq-pro"
end
