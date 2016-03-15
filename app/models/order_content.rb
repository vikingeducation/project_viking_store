class OrderContent < ActiveRecord::Base

  belongs_to :product
  belongs_to :order

  # Want to get the sum of the order_contents quantity * that products price.
  # Do this by combining order_contents table and products table
  # Then joining the orders table on so that we can filter our items that have a checkout_date after the date we've specified.

  def self.total_revenue_since_days_ago(number)
    date = Time.now - number.days
    OrderContent.find_by_sql("SELECT SUM(order_contents.quantity * products.price) as total FROM order_contents JOIN products ON order_contents.product_id=products.id JOIN orders ON orders.id=order_contents.order_id WHERE orders.checkout_date >= '#{date}'")
  end

  def self.average_order_value(number)
    (self.total_revenue_since_days_ago(number).first.total / Order.where("checkout_date IS NOT NULL").count).round(2)
  end
end