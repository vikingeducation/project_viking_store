class Order < ApplicationRecord

  def self.order_created_seven_days
    Order.where('created_at > ?',(Time.now - 7.days)).count 
  end

  def self.order_created_thirty_days
    Order.where('created_at > ?',(Time.now - 30.days)).count 
  end

  def self.order_count
    Order.count 
  end

  def self.revenue_in_seven_days
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
     AND orders.created_at > '#{Time.now - 7.days}'
   ")
  end

   def self.revenue_in_thirty_days
   Order.find_by_sql("
     SELECT SUM(price * quantity) AS sum FROM orders
     JOIN order_contents ON orders.id = order_contents.order_id
     JOIN products on products.id = order_contents.product_id
     WHERE checkout_date IS NOT NULL
     AND orders.created_at > '#{Time.now - 30.days}'
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
