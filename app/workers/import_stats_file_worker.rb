class ImportStatsFileWorker
  include Sidekiq::Worker

  def perform(stats_key)
    s3 = Aws::S3::Client.new
    bucket_name = Rails.application.config.stats.bucket_name

    stats = JSON.parse s3.get_object(
      bucket: bucket_name,
      key: stats_key
    ).body.read

    ActiveRecord::Base.transaction do
      stats.each do |date, name_values|
        name_values.each do |name, version_values|
          version_values.each do |version, count|
            Stat.where(date: date, key: name, value: version).
              first_or_create.
              increment!(:count, count)
          end
        end
      end

      parsed_at = Time.parse(stats_key[0..22] + "Z")
      ParsedLog.create!(filename: stats_key, parsed_at: parsed_at)

      s3.delete_object(bucket: bucket_name, key: stats_key)
    end

    Rails.logger.info "Finished importing #{stats_key}"
  end
end
