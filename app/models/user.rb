class User < ActiveRecord::Base

  def self.new_users(input_day)
  	self.where("created_at > ?", input_day.days.ago).count
  end

  def self.get_top_states
   	result = []
   	table = Order.joins("JOIN addresses ON orders.billing_id = addresses.id")
   	top_states = table.select("addresses.state_id, count(*) AS users").group("addresses.state_id").order("users desc").limit(3)
   	table = top_states.joins("JOIN states ON state_id = states.id")
   	table.select("states.name")
   	result = [
  			 	[table.select("states.name").first[:name], table.select("states.name").first[:users]],
  			 	[table.select("states.name").second[:name], table.select("states.name").second[:users]],
  			 	[table.select("states.name").third[:name], table.select("states.name").third[:users]]
   			]
  end

  def order_address_table
  	table = Order.joins("JOIN addresses ON orders.billing_id = addresses.id")
  	return table
  end

  def self.get_top_cities
    result = []
    table = order.joins("JOIN addresses ON orders.billing_id = addresses.id")
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
