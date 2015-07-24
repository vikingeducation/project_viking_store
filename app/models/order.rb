class Order < ActiveRecord::Base

  def self.revenue
    Order.find_by_sql("SELECT Round(SUM(price),2) as price from order_contents JOIN products ON products.id = product_id")
  end

   def self.revenue_ago(num_days_ago)
    Order.find_by_sql("SELECT Round(SUM(price),2) as price from order_contents JOIN products ON products.id = product_id JOIN orders ON order_id = orders.id where orders.checkout_date > DATETIME('now','-#{num_days_ago} days')")
  end

  def self.count_last(num_days_ago)
    Order.where("checkout_date > ?", num_days_ago.days.ago).count
  end

  def self.top_state_orders
    Order.find_by_sql("select count(*) as counter,states.name  FROM orders JOIN addresses on orders.billing_id = addresses.id Join  states on states.id = addresses.state_id where checkout_date NOTNULL group by state_id ORDER BY counter DESC limit 3")
  end

  def self.top_city_orders
    Order.find_by_sql("select count(*) as counter,cities.name  FROM orders JOIN addresses on orders.billing_id = addresses.id Join  cities on cities.id = addresses.city_id where checkout_date NOTNULL group by city_id ORDER BY counter DESC limit 3")
  end

end
