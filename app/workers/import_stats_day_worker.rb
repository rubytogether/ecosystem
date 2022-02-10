class ImportStatsDayWorker
  include Sidekiq::Worker

  def perform(date)
    import_status_ids = []
    stats = Hash.new { |h, k| h[k] = Hash.new(0) }

    ImportStatus.where(date: date).find_each do |is|
      import_status_ids.push(is.id)

      is.data.each do |name, vv|
        vv.each do |version, count|
          if count.is_a?(Hash)
            stats[name][version] += count["total"]
            stats["#{name}_unique"][version] += count["unique"]
          else
            stats[name][version] += count
          end
        end
      end
    end

    ImportStatus.transaction do
      ImportStatus.where(id: import_status_ids).update_all(
        imported_at: Time.now
      )

      Stat.bulk_insert(
        update_duplicates: %w[date key value], ignore: false
      ) do |t|
        stats.each do |name, value_map|
          value_map.each do |value, count|
            t.add(date: date, key: name, value: value, count: count)
          end
        end
      end
    end

    Rails.logger.info "Finished importing stats for #{date}"
  end
end
