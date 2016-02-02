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
 

end
