class Order < ActiveRecord::Base
	# Return the total number of orders since a particular time.
	# See the view for how to utilize the yield here.
	def self.total_submitted_orders
		if block_given?
			in_timeframe = yield
			in_timeframe.where("checkout_date NOT null").count
		else
			Order.where("checkout_date NOT null").count
		end
	end

	# Returns the total revenue since a particular timeframe.
	# See the view for how to utilize the yield here.
	def self.total_revenue
		if block_given?
			in_timeframe = yield
			in_timeframe.select("SUM(price * quantity) AS total_revenue").
			joins("JOIN products ON order_contents.product_id = products.id JOIN order_contents ON orders.id = order_contents.order_id").
			where("checkout_date IS NOT null").first.total_revenue
		else
			select("SUM(price * quantity) AS total_revenue").
			joins("JOIN products ON order_contents.product_id = products.id JOIN order_contents ON orders.id = order_contents.order_id").
			where("checkout_date IS NOT null").first.total_revenue
		end
	end

	# Returns the name and total order value of the highest order for a 
	# particular time period. This timeframe is given as a block when the 
	# method is called, for now it will be an ActiveRecord::Relation which will
	# then have further queries called on it. Further down I found a better way to 
	# go about this but this method also works.
 	def self.highest_order_value
		if block_given?
			in_timeframe = yield
			in_timeframe.select("users.first_name AS first_name, users.last_name AS last_name, SUM(products.price * order_contents.quantity) AS order_price").
			joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
			where("orders.checkout_date IS NOT null").
			group("order_contents.order_id").
			order("order_price DESC").
			limit(1).first
		else
			select("users.first_name AS first_name, users.last_name AS last_name, SUM(products.price * order_contents.quantity) AS order_price").
			joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
			where("orders.checkout_date IS NOT null").
			group("order_contents.order_id").
			order("order_price DESC").
			limit(1).first
		end
	end

	# Returns the first+last name and total order value for the user 
	# with the highest lifetime order value.
	def self.highest_lifetime_value
		select("users.first_name AS first_name, users.last_name AS last_name, SUM(products.price * order_contents.quantity) AS total_price").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("total_price DESC").
		limit(1).first
	end

	# Returns the first+last name as well as the average order value for the 
	# user with the highest average order value.
	def self.highest_average_value
		select("users.first_name AS first_name, users.last_name AS last_name, AVG(products.price * order_contents.quantity) AS average_value").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("average_value DESC").
		limit(1).first
	end

	# Returns the first+last name, as well as the number of orders, 
	# for the user who has placed the most orders ever.
	def self.most_orders_placed
		select("users.first_name AS first_name, users.last_name AS last_name, COUNT(order_contents.order_id) AS orders").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("orders DESC").
		limit(1).first
	end

	# Average value of all orders w/ timeframe support. NOTE: After
	# messing around with the .yield way of doing timeframes I think that
	# a simple parameter is probably the easiest way to actually go about this.
	# Yield can lead to other problems (for instance, in this situation)
	# when there are aggregate functions and other .where's to be concerned with.
	### TODO: Go back and make all class functions which currently use yield
	### take a timeframe (or similar) parameter.
	def self.average_order_value(timeframe = nil)
			if timeframe.nil?
				average_stats = select("SUM(products.price * order_contents.quantity) AS order_value, COUNT(DISTINCT order_contents.order_id) AS number_of_orders").
				joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
				where("orders.checkout_date IS NOT null").limit(1).first
				average_stats.order_value / average_stats.number_of_orders
			else
				average_stats = select("SUM(products.price * order_contents.quantity) AS order_value, COUNT(DISTINCT order_contents.order_id) AS number_of_orders").
				joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
				where("orders.checkout_date IS NOT null").where("orders.checkout_date >= ?", timeframe).limit(1).first
				average_stats.order_value / average_stats.number_of_orders
			end	
	end

	# This will take a date parameter and return the number of orders 
	# and the value of those orders on a particular day.
	def self.order_by_day(date)
		select("COUNT(DISTINCT orders.id) AS order_quantity, SUM(order_contents.quantity * products.price) AS order_value").
		joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		where("orders.checkout_date BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).
		limit(1).first
	end

	# Returns the quantity of orders and the value of those orders for a given timeframe.
	# Technically it doesn't have to be a week but I am using it as such.
	def self.order_by_week(start_date, end_date)
		select("COUNT(DISTINCT orders.id) AS order_quantity, SUM(order_contents.quantity * products.price) AS order_value").
		joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		where("orders.checkout_date BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day).
		limit(1).first
	end
end
