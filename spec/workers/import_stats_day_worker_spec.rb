require "rails_helper"

RSpec.describe ImportStatsDayWorker, type: :worker do
  let(:start_date) { Date.new(2022, 1, 31) }
  let(:end_date) { Date.new(2022, 2, 1) }

  it "handle old format" do
    Stat.delete_all
    ImportStatus.delete_all
    ImportStatus.import("test", Rails.root.join("spec/support/legacy_stats.json").read)

    worker = ImportStatsDayWorker.new

    expect do
      worker.perform(end_date)
    end.to change { Stat.count }

    expect(Stat.daily_totals("rubygems", start_date)).to be == { end_date => 82598 }
  end

  it "handle new format" do
    Stat.delete_all
    ImportStatus.delete_all

    ImportStatus.import("test", Rails.root.join("spec/support/new_stats.json").read)
    worker = ImportStatsDayWorker.new

    expect do
      worker.perform(end_date)
    end.to change { Stat.count }

    expect(Stat.daily_totals("rubygems", start_date)).to be == { end_date => 82598 }
    expect(Stat.daily_totals("rubygems_unique", start_date)).to be == { end_date => 32717 }
  end
end
