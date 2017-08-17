class Order < ApplicationRecord
  def self.orders_placed(within_days)
    Order.where("checkout_date IS NOT NULL AND created_at >= ? ", Time.now - within_days.days).count
  end
end
