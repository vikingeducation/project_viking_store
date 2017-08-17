class OrderContent < ApplicationRecord
  def self.total_revenue
    OrderContent
    .where("checkout_date IS NOT NULL")
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .joins("JOIN products ON products.id = order_contents.product_id")
    .sum("order_contents.quantity * products.price")
  end
end
