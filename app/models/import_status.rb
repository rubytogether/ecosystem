class ImportStatus < ApplicationRecord
  def self.import(key, json_body)
    json = JSON.parse(json_body)

    json.each do |date, data|
      create!(key: key, date: date, data: data)
    end
  end

  def self.fetched?(key)
    where(key: key).count > 0
  end
end
