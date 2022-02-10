class ImportStatsFileWorker
  include Sidekiq::Worker

  def perform(key)
    return if ImportStatus.fetched?(key)

    s3 = Aws::S3::Client.new
    bucket = Rails.application.config.stats.bucket_name

    body = s3.get_object(bucket: bucket, key: key).body.read
    ImportStatus.import(body)
    Rails.logger.info("Downloaded #{key}")
  end
end
