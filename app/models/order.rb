class Order < ActiveRecord::Base
	def self.total_submitted_orders
		# Allow us to pass in a block which will get the rows in a 
		# particular timeframe.
		if block_given?
			in_timeframe = yield
			in_timeframe.where("checkout_date NOT null").count
		else
			Order.where("checkout_date NOT null").count
		end
	end

	def self.total_revenue
		# Allow us to pass in a block which will get the rows in a 
		# particular timeframe.
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

	# Highest single order value.
	def self.highest_order_value
		select("users.first_name AS first_name, users.last_name AS last_name, SUM(products.price * order_contents.quantity) AS order_price").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("order_contents.order_id").
		order("order_price DESC").
		limit(1).first
	end

	# Highest lifetime order value
	def self.highest_lifetime_value
		select("users.first_name AS first_name, users.last_name AS last_name, SUM(products.price * order_contents.quantity) AS total_price").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("total_price DESC").
		limit(1).first
	end

	# Highest average order value
	def self.highest_average_value
		select("users.first_name AS first_name, users.last_name AS last_name, AVG(products.price * order_contents.quantity) AS average_value").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("average_value DESC").
		limit(1).first
	end

	# Most orders placed
	def self.most_orders_placed
		select("users.first_name AS first_name, users.last_name AS last_name, COUNT(order_contents.order_id) AS orders").
		joins("JOIN users ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id").
		where("orders.checkout_date IS NOT null").
		group("users.id").
		order("orders DESC").
		limit(1).first
	end
end
