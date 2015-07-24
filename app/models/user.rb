class User < ActiveRecord::Base

  def self.count_last_30
    User.where("created_at > ?", 30.days.ago).count
  end

  def self.count_last_7
    User.where("created_at > ?", 7.days.ago).count
  end

  def self.highest_order_value
    User.find_by_sql("SELECT users.first_name, users.last_name, ROUND(sum(price*quantity),2) AS sum, quantity FROM products JOIN order_contents ON products.id=order_contents.product_id JOIN orders ON orders.id = order_contents.order_id JOIN users ON orders.user_id = users.id GROUP BY order_id ORDER BY sum DESC LIMIT 1")
  end

  def self.highest_lifetime_value
    User.find_by_sql("SELECT users.first_name, users.last_name, ROUND(sum(price*quantity),2) AS sum, quantity FROM products JOIN order_contents ON products.id=order_contents.product_id JOIN orders ON orders.id = order_contents.order_id JOIN users ON orders.user_id = users.id GROUP BY user_id ORDER BY sum DESC LIMIT 1")
  end
  def self.highest_avg_value
    User.find_by_sql("SELECT users.first_name, users.last_name, ROUND(avg(price*quantity),2) AS sum, quantity FROM products JOIN order_contents ON products.id=order_contents.product_id JOIN orders ON orders.id = order_contents.order_id JOIN users ON orders.user_id = users.id GROUP BY user_id ORDER BY sum DESC LIMIT 1")
  end
  def self.most_orders_placed
    User.find_by_sql("SELECT users.first_name, users.last_name, count(order_id) AS sum FROM products JOIN order_contents ON products.id=order_contents.product_id JOIN orders ON orders.id = order_contents.order_id JOIN users ON orders.user_id = users.id GROUP BY order_id ORDER BY sum DESC LIMIT 1")
  end
end
