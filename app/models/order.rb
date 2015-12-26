class Order < ActiveRecord::Base
  scope :days_ago, -> (days_past = 7) { where("checkout_date > ?", days_past.days.ago) }

  scope :completed, -> { where("checkout_date IS NOT NULL")}
end
