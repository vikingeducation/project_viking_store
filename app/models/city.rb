class City < ActiveRecord::Base

  def self.top_cities(limit = 3)
		top_cities = []

		c = City.joins("JOIN addresses ON cities.id = city_id JOIN users ON addresses.id = users.billing_id").group("cities.id").select("cities.name, count (cities.id) as total").order("total desc").limit(limit)

		c.each do |city|
			top_cities << { name: city.name, total: city.total }
		end

		top_cities
	end

end
