class User < ActiveRecord::Base
  # Overall Platform Panel
  def self.number_of_users(number_of_days=nil)
    if number_of_days.nil?
      User.where("created_at IS NOT NULL").count
    else
      User.where("created_at > ?", number_of_days.days.ago).count
    end
  end

  # User Demographics and Behavior Panel
  def self.top_states
    User.select("states.name, COUNT(*) AS number_of_users").joins("JOIN addresses ON users.id = addresses.user_id JOIN states ON addresses.state_id = states.id").group("states.name").order("number_of_users DESC").limit(3)
  end

  def self.top_cities
    User.select("cities.name, COUNT(*) AS number_of_users").joins("JOIN addresses ON users.id = addresses.user_id JOIN cities ON addresses.city_id = cities.id").group("cities.name").order("number_of_users DESC").limit(3)
  end

  def self.highest_single_order_value
    User.select("first_name, last_name, quantity*price AS value").joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL").group("orders.id").order("value DESC").limit(3)
  end

  def self.highest_lifetime_value
    User.select("first_name, last_name, SUM(quantity*price) AS lifetime_spent").joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").where("checkout_date IS NOT NULL").group("users.id").order("lifetime_spent DESC").limit(3)
  end

  def self.highest_average_order_value
    User.select("first_name, last_name, ((SUM(quantity*price))/COUNT(orders.id)) AS avg").joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").group("users.id").order("avg DESC").limit(1)
  end

  def self.most_orders_placed
    User.select("first_name, last_name, COUNT(*) AS orders").joins("JOIN orders ON users.id = orders.user_id").group("users.id").order("orders DESC").limit(1)
  end

end
