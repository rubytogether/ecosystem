class ImportStatsWorker
  include Sidekiq::Worker

  def perform(*args)
    s3 = Aws::S3::Client.new
    bucket_name = Rails.application.config.stats.bucket_name
    prefix = Rails.application.config.stats.prefix

    pending_stats = s3.list_objects_v2(
      bucket: bucket_name,
      prefix: prefix
    ).contents.map(&:key)

    Rails.logger.info "Found #{pending_stats.count} pending stats files"

    Sidekiq::Client.push_bulk(
      'class' => "ImportStatsFileWorker",
      'args' => pending_stats.map{|k| [k] }
    )
  end
end
