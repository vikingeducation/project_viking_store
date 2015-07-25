class City < ActiveRecord::Base

  def self.get_top_cities
    result = []
    table = User.joins("JOIN addresses ON users.billing_id = addresses.id")
    top_cities = table.select("addresses.city_id, count(*) AS users").group("addresses.city_id").order("users desc").limit(3)
    table = top_cities.joins("JOIN cities ON city_id = cities.id")
    table.select("cities.name")
    result = [
          [table.select("cities.name").first[:name], table.select("cities.name").first[:users]],
          [table.select("cities.name").second[:name], table.select("cities.name").second[:users]],
          [table.select("cities.name").third[:name], table.select("cities.name").third[:users]]
        ]
  end
end
