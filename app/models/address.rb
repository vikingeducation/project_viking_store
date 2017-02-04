class Address < ApplicationRecord
	belongs_to :city
	belongs_to :state
	belongs_to :customer, :class_name => "User", foreign_key: :user_id
	belongs_to :user
	has_many :used_as_billing, :class_name => "Order", foreign_key: :billing_id
	has_many :used_as_shipping, :class_name => "Order", foreign_key: :shipping_id

	validates 	:street_address, :city_id, :state_id,
				:presence => true
	validates 	:street_address, :length =>{ :in => 1..64 }

	def self.get_top_4_states 
		Address.select("count(addresses.state_id), states.name").
			joins("JOIN users ON users.billing_id = addresses.id").
			joins("JOIN states ON addresses.state_id = states.id").
			group("states.name").order("count" => :desc).limit(4)
	end

	def self.get_top_4_cities 
		Address.select("count(addresses.city_id), cities.name").
			joins("JOIN users ON users.billing_id = addresses.id").
			joins("JOIN cities ON addresses.city_id = cities.id").
			group("cities.name").order("count" => :desc).limit(4)
	end

	def self.get_state_demography
		states_array = Address.get_top_4_states
		table_state = Array.new(5) { Array.new }
		table_state[0][0] = 'Item';
		table_state[0][0] = 'Data';
		table_state[1][0] = states_array[0].name
		table_state[2][0] = states_array[1].name
		table_state[3][0] = states_array[2].name
		table_state[4][0] = states_array[3].name

		table_state[1][1] = states_array[0].count
		table_state[2][1] = states_array[1].count
		table_state[3][1] = states_array[2].count
		table_state[4][1] = states_array[3].count
		table_state
	end

	def self.get_city_demography
		cities_array = Address.get_top_4_cities
		table_city = Array.new(5) { Array.new }
		table_city[0][0] = 'Item';
		table_city[0][0] = 'Data';
		table_city[1][0] = cities_array[0].name
		table_city[2][0] = cities_array[1].name
		table_city[3][0] = cities_array[2].name
		table_city[4][0] = cities_array[3].name

		table_city[1][1] = cities_array[0].count
		table_city[2][1] = cities_array[1].count
		table_city[3][1] = cities_array[2].count
		table_city[4][1] = cities_array[3].count
		table_city
	end
end
