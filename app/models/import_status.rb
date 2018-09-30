class ImportStatus < ApplicationRecord
  def self.fetched?(key)
    where(key: key).count > 0
  end
end
