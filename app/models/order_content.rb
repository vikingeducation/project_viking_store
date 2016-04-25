class OrderContent < ActiveRecord::Base
  # Definitely no need to destroy or null anything when it comes to dependents and join tables.
  belongs_to :product
  belongs_to :order

  # Want to get the sum of the order_contents quantity * that products price.
  # Do this by combining order_contents table and products table
  # Then joining the orders table on so that we can filter our items that have a checkout_date after the date we've specified.

  def self.total_revenue_since_days_ago(number_of_days)
    date = Time.now - number_of_days.days
    OrderContent.find_by_sql("SELECT SUM(order_contents.quantity * products.price) as total 
                              FROM order_contents 
                              JOIN products 
                                ON order_contents.product_id=products.id 
                              JOIN orders 
                                ON orders.id=order_contents.order_id 
                              WHERE orders.checkout_date >= '#{date}'")
  end

  def self.biggest_order(number_of_days)
    date = Time.now - number_of_days.days
    OrderContent.find_by_sql("SELECT order_contents.order_id, SUM(order_contents.quantity * products.price) as amount 
                              FROM orders 
                              JOIN order_contents 
                                ON orders.id=order_contents.order_id 
                              JOIN products 
                                ON order_contents.product_id=products.id 
                              WHERE orders.checkout_date > '#{date}' 
                              GROUP BY order_contents.order_id 
                              ORDER BY amount DESC 
                              LIMIT 1")
  end

  def self.average_order(number_of_days)
    (OrderContent.total_revenue_since_days_ago(number_of_days).first.total/Order.created_since_days_ago(number_of_days)).round(2)
  end

  # Total price for many of the same item in an order
  def total
    self.quantity * self.product.price
  end
end
