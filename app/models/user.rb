class User < ActiveRecord::Base

  def self.new_users(time_period)
    User.where("created_at > ?", time_period).count
  end

  def self.in_the_last_seven_days
    self.new_users(7.days.ago)
  end

  def self.in_the_last_thirty_days
    self.new_users(30.days.ago)
  end

  def self.states_by_shipping_address
    User.select("states.name, COUNT(*) AS users_by_state").
      joins("JOIN addresses ON users.shipping_id = addresses.id JOIN states ON addresses.state_id = states.id").
      group("states.name").
      order("users_by_state DESC").
      limit(3)
  end

  def self.cities_by_shipping_address
    User.select("cities.name, COUNT(*) AS users_by_city").
      joins("JOIN addresses ON users.shipping_id = addresses.id JOIN cities ON addresses.state_id = cities.id").
      group("cities.name").
      order("users_by_city DESC").
      limit(3)
  end

  def self.highest_single_order_value
    User.select("first_name, last_name, quantity * price AS order_value").
      joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id").
      where("checkout_date IS NOT NULL").
      group("orders.id").
      order("order_value DESC").
      limit(1).
      first
  end
end
