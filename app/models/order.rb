class Order < ApplicationRecord
  # calculates the number of new Orders that were placed within a number of
  # days from the current day
  def self.orders_placed(within_days)
    Order.where("checkout_date IS NOT NULL AND created_at >= ? ", Time.now - within_days.days).count
  end
end
