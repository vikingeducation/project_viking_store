class Product < ApplicationRecord
  scope :listed_since, ->(begin_date) {
    where('created_at > ? AND created_at < ?', begin_date, Time.zone.now)
  }
end
