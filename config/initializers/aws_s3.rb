require "aws-sdk-core"

Aws.config.update({
  region: "us-west-2",
  logger: ::Rails.logger
})

Rails.application.config.stats = {
  bucket_name: ENV.fetch("STATS_BUCKET_NAME", "rubygems-logs-staging.rubytogether"),
  prefix: ENV.fetch("STATS_BUCKET_PREFIX", "fastly_json/")
}
