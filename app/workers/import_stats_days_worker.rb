class ImportStatsDaysWorker
  include Sidekiq::Worker

  def perform
    dates = ImportStatus.where("imported_at IS NULL").pluck(:date).uniq
    dates -= [Time.now.utc.to_date]

    Sidekiq::Client.push_bulk(
      'class' => "ImportStatsDayWorker",
      'args' => dates.map{|d| [d] }
    )
  end
end
