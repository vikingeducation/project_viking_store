class City < ApplicationRecord
  def self.top_cities
    City.select("cities.name, COUNT(cities.name) AS users_sum").joins("
    JOIN addresses ON cities.id = addresses.city_id").joins("
    JOIN users ON addresses.id = users.billing_id").group("
    cities.name").order("
    COUNT(cities.name) DESC").limit(3)
  end
end
