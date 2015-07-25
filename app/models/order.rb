class Order < ActiveRecord::Base

  def self.revenue
    Order.find_by_sql("SELECT Round(SUM(quantity*price),2) as price from order_contents JOIN products ON products.id = product_id")
  end

   def self.revenue_ago(num_days_ago)
    Order.find_by_sql("SELECT Round(SUM(price),2) as price from order_contents JOIN products ON products.id = product_id JOIN orders ON order_id = orders.id where orders.checkout_date > DATETIME('now','-#{num_days_ago} days')")
  end

  def self.count_last(num_days_ago)
    Order.where("checkout_date > ?", num_days_ago.days.ago).count
  end

  def self.top_state_orders
    Order.select("count(*) as counter, states.name").joins("JOIN addresses on orders.billing_id = addresses.id").joins("Join  states on states.id = addresses.state_id").where("checkout_date NOTNULL").group("state_id").order("counter DESC").limit("3")
  end

  def self.top_city_orders
    Order.find_by_sql("select count(*) as counter,cities.name  FROM orders JOIN addresses on orders.billing_id = addresses.id Join  cities on cities.id = addresses.city_id where checkout_date NOTNULL group by city_id ORDER BY counter DESC limit 3")
  end

  def self.avg_order_value
    Order.find_by_sql("SELECT ROUND(sum(price*quantity)/count(DISTINCT order_id),2) as avg FROM products JOIN order_contents ON
        products.id = order_contents.product_id  JOIN orders ON order_id = orders.id")
  end

  

  def self.avg_order_value_ago(num_days_ago)
    Order.find_by_sql("SELECT Round(sum(price*quantity)/count(DISTINCT order_id),2) as avg FROM products JOIN order_contents ON
 products.id = order_contents.product_id  JOIN orders ON order_id = orders.id WHERE checkout_date > DATETIME('now','-#{num_days_ago} days')")
  end


  def self.largest_order_value_ago(num_days_ago)
    Order.find_by_sql("SELECT checkout_date, ROUND(sum(price*quantity),2) AS sum, quantity FROM products JOIN order_contents ON products.id=order_contents.product_id JOIN orders ON orders.id = order_contents.order_id GROUP BY order_id HAVING orders.checkout_date >DATETIME('now','-#{num_days_ago} days') ORDER BY sum DESC  LIMIT 1")
  end



  



end
