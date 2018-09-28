require "aws-sdk-core"

Aws.config.update({
  region: "us-west-2",
  logger: ::Rails.logger
})
