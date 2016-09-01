class Order < ActiveRecord::Base

  def self.new_orders(days_since)
    self.where("checkout_date > '#{DateTime.now - days_since}'").count
  end

  def self.total
    self.count
  end

  def self.revenue(days_since)
    self.join_with_products.where("checkout_date > '#{DateTime.now - days_since}'")
        .sum("price * quantity")
  end

  def self.total_revenue
    self.join_with_products.sum("order_contents.quantity * products.price")
  end

  def self.highest_single_order_user
    self.select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("orders.id, users.first_name, users.last_name")
        .order('order_value desc')
        .limit(1)
  end

  def self.highest_lifetime_order_user
    self.select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('order_value desc')
        .limit(1)
  end

  def self.highest_avg_order_user
    self.select("users.first_name, users.last_name, COUNT(distinct orders.id) AS order_count,
                 SUM(order_contents.quantity * products.price) AS order_value,
                 sum(price * quantity) / count(distinct orders.id) AS avg_price")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('avg_price desc')
        .limit(1)
  end


  def self.most_orders_user
    self.select("users.first_name, users.last_name, COUNT(users.id) AS order_count")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('order_count desc')
        .limit(1)
  end


  def self.orders_with_values
    self.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .group("orders.id")
        .order('order_value desc')
  end

  def self.order_and_products
    self.select("orders.id, order_contents.product_id, order_contents.quantity, products.price")
        .join_with_products
  end

  def self.join_with_users
    joins("JOIN users ON orders.user_id = users.id")
  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end
end
