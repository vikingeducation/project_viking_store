class User < ActiveRecord::Base
	def self.total
		# Allow us to pass in a block which will get the rows in a 
		# particular timeframe.
		if block_given?
			in_timeframe = yield
			in_timeframe.count
		else
			User.count
		end
	end

	# Get the 3 states that have the highest 
	# number of clients based on our billing addresses.
	def self.top_states
		select("states.name AS name, COUNT(*) AS client_total ").
		joins("JOIN addresses ON users.billing_id = addresses.id JOIN states ON addresses.state_id = states.id").
		where("billing_id IS NOT null").
		group("states.name").
		order("client_total DESC").
		limit(3)
	end

	# Get the 3 cities that have the greatest 
	# number of clients based on our billing addresses.
	def self.top_cities
		select("cities.name AS name, COUNT(*) AS client_total ").
		joins("JOIN addresses ON users.billing_id = addresses.id JOIN cities ON addresses.city_id = cities.id").
		where("billing_id IS NOT null").
		group("cities.name").
		order("client_total DESC").
		limit(3)
	end
end
