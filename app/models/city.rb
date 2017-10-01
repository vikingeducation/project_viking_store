class City < ApplicationRecord

  validates :name, length: {minimum: 1, maximum: 64 }
   def self.top_three_cities
    City.find_by_sql("
      SELECT cities.name, COUNT(users.id) as num_users FROM users
      JOIN orders on users.id = orders.user_id
      JOIN addresses on orders.billing_id = addresses.id
      JOIN cities on addresses.city_id = cities.id
      GROUP BY cities.id
      ORDER by num_users DESC
      LIMIT 3
      ")
  end
end
