class User < ActiveRecord::Base


  def full_name
    first_name + " " + last_name
  end

  def self.new_users(num_days)
    User.where("created_at >= ? ", num_days.days.ago)
  end

  def self.top_states
    User.select("states.name").joins("JOIN addresses ON addresses.id = users.billing_id JOIN states ON states.id = addresses.state_id").group("states.name").order("COUNT(states.name) DESC").limit(3).count
  end

  def self.top_cities
    User.select("cities.name").joins("JOIN addresses ON addresses.id = users.billing_id JOIN cities ON cities.id = addresses.state_id").group("cities.name").order("COUNT(cities.name) DESC").limit(3).count
  end

  def self.highest_order_value
    User.select("users.*, SUM(price * quantity)").joins("JOIN orders ON user_id = users.id JOIN order_contents ON order_id = orders.id JOIN products ON product_id = products.id").group("users.id, order_id").order("SUM(price * quantity) DESC")
  end
end
