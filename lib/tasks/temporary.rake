namespace :temporary do
  desc "one-off tasks"
  task destroy_duplicate_stats: :environment do
    # delete all duplicate rows preserving the row with the maximum count
    Stat.where.not(id: Stat.order(:date, :key, :value, "count desc").select("distinct on (date, key, value) id")).delete_all
  end
end
