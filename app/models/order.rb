class Order < ApplicationRecord

  def self.order_count
    Order.count 
  end

  def self.order_created(days)
    Order.where('created_at > ?',(Time.now - days.days)).count 
  end

  def self.revenue_created(days)
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
     AND orders.created_at > '#{Time.now - days.days}'
   ")
  end

  def self.average_order(days)
    User.find_by_sql("
      SELECT AVG(price * quantity) AS order_value FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      WHERE checkout_date IS NOT NULL
      AND orders.created_at > '#{Time.now - days.days}'
      ")
  end

  def self.avg_order
    User.find_by_sql("
      SELECT AVG(price * quantity) AS order_value FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      WHERE checkout_date IS NOT NULL
      ")
  end

  def self.max_order(days)
    User.find_by_sql("
      SELECT MAX(price * quantity) AS order_value FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      WHERE checkout_date IS NOT NULL
      AND orders.created_at > '#{Time.now - days.days}'
      ")
  end

   def self.max_ord
    User.find_by_sql("
      SELECT MAX(price * quantity) AS order_value FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      WHERE checkout_date IS NOT NULL
      ")
  end

   def self.total_revenue
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
   ")
  end

   def self.orders_by_day
    Order.find_by_sql("
      SELECT
      DATE(days) AS day,
      COUNT(orders.*) AS num_orders,
      SUM(price * quantity) AS sum
      FROM GENERATE_SERIES((
        SELECT DATE(MIN(checkout_date)) FROM orders
      ), CURRENT_DATE, '1 DAY'::INTERVAL) days
      LEFT JOIN orders ON DATE(orders.checkout_date) = days
      LEFT JOIN order_contents ON orders.id = order_contents.order_id
      LEFT JOIN products on products.id = order_contents.product_id
      GROUP BY days
      ORDER BY days DESC
    ")
  end


  def self.orders_by_week
    Order.find_by_sql("
      SELECT
      DATE(weeks) AS week,
      COUNT(orders.*) AS num_orders,
      SUM(price * quantity) AS sum
      FROM GENERATE_SERIES((
        SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) 
        FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) weeks
      LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks
      LEFT JOIN order_contents ON orders.id = order_contents.order_id
      LEFT JOIN products on products.id = order_contents.product_id
      GROUP BY weeks
      ORDER BY weeks DESC
    ")
  end
end
