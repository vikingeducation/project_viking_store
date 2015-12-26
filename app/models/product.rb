class Product < ActiveRecord::Base
  scope :days_ago, -> (days_past = 7) { where("created_at > ?", days_past.days.ago) }
end
