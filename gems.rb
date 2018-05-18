source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby Pathname.new(".ruby-version").expand_path(__dir__).read

gem "rails", "~> 5.2.0"

gem "bootsnap", ">= 1.1.0", require: false
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "webpacker"

group :development, :test do
  gem "pry-rails"
  gem "pry-byebug", require: false
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
end

gem "chartkick", "~> 2.3"
