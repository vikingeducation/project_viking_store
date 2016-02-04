class User < ActiveRecord::Base


  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("created_at > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.top_states
    self.select("COUNT(*) AS user_count, states.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN states ON states.id = addresses.state_id").group("states.name").order("user_count DESC").limit(3)
  end

  def self.top_cities
    self.select("COUNT(*) AS user_count, cities.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN cities ON cities.id = addresses.city_id").group("cities.name").order("user_count DESC").limit(3)
  end

<<<<<<< HEAD
  def self.user_address
    self.select("cities.name, states.name").
    joins("JOIN addresses ON addresses.user_id = users.id").
    joins("JOIN cities ON addresses.city_id = cities.id").
    joins("JOIN states ON addresses.state_id = states.id")
  end


end
=======
  def self.user_data
    self.select("users.id AS ID, users.first_name AS Name, users.created_at AS Joined, cities.name AS City, states.name AS state, COUNT(orders.id) AS Orders").
    joins("JOIN addresses ON addresses.id = users.billing_id").
    joins("JOIN cities ON addresses.city_id = cities.id").
    joins("JOIN states ON addresses.state_id = states.id").
    joins("JOIN orders ON orders.user_id = users.id").
    group("users.id, city, state").
    order("ID")
  end


  def self.last_order_date(id)
    self.select("orders.checkout_date AS date").
    joins("JOIN orders ON orders.user_id = users.id").
    where("orders.checkout_date IS NOT NULL AND users.id = #{id}").
    order("orders.checkout_date DESC").
    limit 1
  end


# SELECT users.id as userss, orders.id as orderss, orders.checkout_date
# FROM users JOIN orders ON orders.user_id = users.id
# WHERE orders.checkout_date IS NOT NULL AND users.id = 2
# GROUP BY users.id, orders.id
# ORDER BY orders.checkout_date DESC 
# LIMIT 1

end
>>>>>>> b9f118943be41dec7064101c2b45638a98421fa5
