class User < ActiveRecord::Base

  def self.new_users_since(start_date)
    users = User.where("created_at > '#{start_date}'").count
  end

  def self.total_users
    User.all.count
  end

  def self.top_user_states
    User.select("COUNT(states.name), states.name").joins("JOIN addresses ON users.billing_id = addresses.id").joins("JOIN states ON addresses.state_id = states.id").group("states.name").order("COUNT(states.name) DESC").limit(3)
  end

  def self.top_user_cities
    User.select("COUNT(cities.name), cities.name").joins("JOIN addresses ON users.billing_id = addresses.id").joins("JOIN cities ON addresses.city_id = cities.id").group("cities.name").order("COUNT(cities.name) DESC").limit(3)
  end
 
  def self.highest_single_order_value
    User.select("orders.id, first_name ||' '|| last_name AS full_name, SUM(quantity * price)").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").group("orders.id, first_name, last_name").order("sum DESC").limit(1).to_a[0]
  end

  def self.highest_lifetime_value
    User.select("users.id, first_name ||' '|| last_name AS full_name, SUM(quantity * price)").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").group("users.id, first_name, last_name").order("sum DESC").limit(1).to_a[0]
  end

  def self.order_value_sum
    User.select("SUM(quantity * price) AS order_sum").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id")
  end

  def self.grouped_order_value_sum
    User.select("users.*, SUM(quantity * price) AS order_sum").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").group("users.id")
  end

  def self.order_value_avg
    User.select("AVG(quantity * price) AS average").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id")
  end

  def self.grouped_order_value_avg
    User.select("users.*, AVG(quantity * price) AS average").joins("JOIN orders ON users.id = orders.user_id").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON order_contents.product_id = products.id").group("users.id")
  end

  def self.highest_average_order_value
    self.grouped_order_value_avg.order("average DESC").limit(1).to_a[0]
  end

  def self.most_orders
    User.select("users.*, COUNT(orders.id) AS orders").joins("JOIN orders ON users.id = orders.user_id").group("users.id").order("orders DESC").limit(1).to_a[0]
  end

  # def self.do_query
  #   User.join_other_table("SELECT *").where("other_table.field = value")
  # end

  # def self.join_other_table(sql)
  #   User.select(sql)
  #   .join("JOIN other_table ON users.id = other_table.user_id")
  # end
end
