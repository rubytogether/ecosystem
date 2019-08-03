class ImportStatsFileWorker
  include Sidekiq::Worker

  def perform(key)
    return if ImportStatus.fetched?(key)

    s3 = Aws::S3::Client.new
    bucket = Rails.application.config.stats.bucket_name

    body = s3.get_object(bucket: bucket, key: key).body.read
    json = JSON.parse(body)

    json.each do |date, data|
      ImportStatus.create!(key: key, date: date, data: data)
    end

    Rails.logger.info("Downloaded #{key}")
  end
end
