class ImportStatsWorker
  include Sidekiq::Worker

  def perform
    s3 = Aws::S3::Client.new
    bucket_name = Rails.application.config.stats.bucket_name
    prefix = Rails.application.config.stats.prefix

    last_key = ImportStatus.order("key COLLATE \"C\" DESC").
      limit(1).pluck(:key).first
    keys = s3.list_objects_v2(
      bucket: bucket_name, prefix: prefix, start_after: last_key
    ).contents.map(&:key)

    Rails.logger.info "Found #{keys.size} pending stats files"

    Sidekiq::Client.push_bulk(
      "class" => "ImportStatsFileWorker", "args" => keys.map { |k| [k] }
    )

    if keys.size == 1000
      self.class.perform_in(5.minutes)
    else
      ImportStatsDaysWorker.perform_in(5.minutes)
    end
  end
end
