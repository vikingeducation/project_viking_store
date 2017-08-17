class OrderContent < ApplicationRecord
  # calculates the total revenue over all time
  def self.total_revenue
    OrderContent
    .where("orders.checkout_date IS NOT NULL")
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .joins("JOIN products ON products.id = order_contents.product_id")
    .sum("order_contents.quantity * products.price")
  end

  # calculates revenue within a number of days
  def self.revenue(within_days)
    OrderContent
    .where("orders.checkout_date IS NOT NULL AND order_contents.created_at >= ?", Time.now - within_days.days)
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .joins("JOIN products ON products.id = order_contents.product_id")
    .sum("order_contents.quantity * products.price")
  end
end
