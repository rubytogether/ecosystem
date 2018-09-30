class ImportStatsFileWorker
  include Sidekiq::Worker

  def perform(key)
    return if ImportStatus.fetched?(key)

    s3 = Aws::S3::Client.new
    bucket= Rails.application.config.stats.bucket_name

    body = s3.get_object(bucket: bucket, key: key).body.read
    json = JSON.parse(body)
    date, data = json.keys.first, json.values.first

    ImportStatus.create!(key: key, date: date, data: data)
    Rails.logger.info("Downloaded #{key}")
  end
end
