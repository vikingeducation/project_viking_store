class Product < ActiveRecord::Base
  scope :days_ago, -> (days_past = 7) { where("created_at > ?", days_past.days.ago) }
  scope :day_range, -> (start_day, end_day) {where("created_at >= ? AND created_at <= ?", start_day.days.ago, end_day.days.ago)}
end
