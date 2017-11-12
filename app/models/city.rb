class City < ApplicationRecord
  def self.top_three_of_users
    joins("INNER JOIN addresses ON cities.id = addresses.city_id").
      joins("INNER JOIN users ON users.billing_id = addresses.id").
      group("cities.name").
      order("count_cities_id DESC").
      limit(3).
      count("cities.id")
  end
end
