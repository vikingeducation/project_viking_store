class Order < ApplicationRecord
  # calculates the number of new Orders that were placed within a number of
  # days from the current day
  def self.orders_placed(within_days)
    Order
    .where("checkout_date IS NOT NULL AND created_at >= ? ", Time.now - within_days.days)
    .count
  end

  # finds the User with the most Orders placed
  def self.user_with_most_orders_placed
    Order
    .joins("JOIN users ON users.id = orders.user_id")
    .where("checkout_date IS NOT NULL")
    .select("users.first_name, users.last_name, COUNT(orders.id) AS order_count")
    .group("users.id, users.first_name, users.last_name")
    .order("order_count DESC")
    .limit(1)
    .first
  end
end
