class DashboardController < ApplicationController

	def index
		populate_panel1_t1
		populate_panel1_t2
		populate_panel1_t3

		populate_panel2_t1
		populate_panel2_t2
		populate_panel2_t3

		populate_panel3_t1
		populate_panel3_t2
		populate_panel3_t3
	end

	def populate_panel3_t1
		@p3_table_7 = initial_data_p1
		@p3_table_7[1][0] = 'Number of Orders'
		@p3_table_7[2][0] = 'Total Revenue'
		@p3_table_7[3][0] = 'Average Order Value'
		@p3_table_7[4][0] = 'Largest Order Value'

		@p3_table_7[1][1] = "#{Order.past_days(7).count}"
		revenue_7 = Order.purchases_period(Time.now - 7.days,Time.now).sum("quantity * price")
		@p3_table_7[2][1] = "$#{revenue_7}"

		t1 = Time.now - 7.days
		t2 = Time.now

		average_of_orders = Order.find_by_sql "SELECT AVG(revenue) FROM 
								(SELECT orders.id AS order_id, SUM(quantity * price) AS revenue 
									FROM orders JOIN order_contents ON orders.id = order_contents.order_id 
									JOIN products ON order_contents.product_id = products.id 
									WHERE checkout_date BETWEEN '#{t1}' AND '#{t2}' GROUP BY orders.id) AS average_table"

		@p3_table_7[3][1] = "$#{average_of_orders[0].avg.to_f.round(2)}"
		

		largest_order = Order.revenue_table.where(:checkout_date => Time.now - 7.days..Time.now).limit(1)[0].revenue.to_f
		@p3_table_7[4][1] = "$#{largest_order}"
    end

	def populate_panel3_t2
		@p3_table_30 = initial_data_p1
		@p3_table_30[1][0] = 'Number of Orders'
		@p3_table_30[2][0] = 'Total Revenue'
		@p3_table_30[3][0] = 'Average Order Value'
		@p3_table_30[4][0] = 'Largest Order Value'

		@p3_table_30[1][1] = "#{Order.past_days(30).count}"
		revenue_30 = Order.purchases_period(Time.now - 30.days,Time.now).sum("quantity * price")
		@p3_table_30[2][1] = "$#{revenue_30}"

		t1 = Time.now - 30.days
		t2 = Time.now

		average_of_orders = Order.find_by_sql "SELECT AVG(revenue) FROM 
								(SELECT orders.id AS order_id, SUM(quantity * price) AS revenue 
									FROM orders JOIN order_contents ON orders.id = order_contents.order_id 
									JOIN products ON order_contents.product_id = products.id 
									WHERE checkout_date BETWEEN '#{t1}' AND '#{t2}' GROUP BY orders.id) AS average_table"

		@p3_table_30[3][1] = "$#{average_of_orders[0].avg.to_f.round(2)}"

		largest_order = Order.revenue_table.where(:checkout_date => Time.now - 30.days..Time.now).limit(1)[0].revenue.to_f
		@p3_table_30[4][1] = "$#{largest_order}"
	end

	def populate_panel3_t3
		@p3_table_total = initial_data_p1
		@p3_table_total[1][0] = 'Number of Orders'
		@p3_table_total[2][0] = 'Total Revenue'
		@p3_table_total[3][0] = 'Average Order Value'
		@p3_table_total[4][0] = 'Largest Order Value'

		@p3_table_total[1][1] = "#{Order.placed.count}"
		revenue_total = Order.purchases_all.sum("quantity * price")
		@p3_table_total[2][1] = "$#{revenue_total}"

		average_of_orders = Order.find_by_sql "SELECT AVG(revenue) FROM 
								(SELECT orders.id AS order_id, SUM(quantity * price) AS revenue 
									FROM orders JOIN order_contents ON orders.id = order_contents.order_id 
									JOIN products ON order_contents.product_id = products.id 
									WHERE checkout_date IS NOT NULL GROUP BY orders.id) AS average_table"

		@p3_table_total[3][1] = "$#{average_of_orders[0].avg.to_f.round(2)}"

		largest_order = Order.revenue_table.where.not(:checkout_date => nil).limit(1)[0].revenue.to_f
		@p3_table_total[4][1] = "$#{largest_order}"
	end

	def populate_panel2_t1
		@p2_table_state     = initial_data_p1
		states_array = top_4_states
		@p2_table_state[1][0] = states_array[0].name
		@p2_table_state[2][0] = states_array[1].name
		@p2_table_state[3][0] = states_array[2].name
		@p2_table_state[4][0] = states_array[3].name

		@p2_table_state[1][1] = states_array[0].count
		@p2_table_state[2][1] = states_array[1].count
		@p2_table_state[3][1] = states_array[2].count
		@p2_table_state[4][1] = states_array[3].count
	end

	def populate_panel2_t2
		@p2_table_city     = initial_data_p1
		cities_array = top_4_cities
		@p2_table_city[1][0] = cities_array[0].name
		@p2_table_city[2][0] = cities_array[1].name
		@p2_table_city[3][0] = cities_array[2].name
		@p2_table_city[4][0] = cities_array[3].name

		@p2_table_city[1][1] = cities_array[0].count
		@p2_table_city[2][1] = cities_array[1].count
		@p2_table_city[3][1] = cities_array[2].count
		@p2_table_city[4][1] = cities_array[3].count
	end

	def populate_panel2_t3
		@p2_table_best_user = initial_data_p2
		@p2_table_best_user[1][0] = 'Highest Single Order Value'
		@p2_table_best_user[2][0] = 'Highest Lifetime Value'
		@p2_table_best_user[3][0] = 'Highest Average Order Value'
		@p2_table_best_user[4][0] = 'Most Orders Placed'

		main_user = top_user_overall
		main_order = top_order_overall
		avg_user = top_avg_user

		most_placed = most_order_user

		user_best_order = User.find(main_order.user_id)

		@p2_table_best_user[1][1] = "#{user_best_order.first_name} #{user_best_order.last_name}"
		@p2_table_best_user[1][2] = "$#{main_order.revenue.to_f}"

		@p2_table_best_user[2][1] = "#{main_user.first_name} #{main_user.last_name}"
		@p2_table_best_user[2][2] = "$#{main_user.revenue.to_f}"
		
		@p2_table_best_user[3][1] = "#{avg_user.first_name} #{avg_user.last_name}"
		@p2_table_best_user[3][2] = "$#{avg_user.avg.to_f}"

		@p2_table_best_user[4][1] = "#{most_placed.first_name} #{most_placed.last_name}"
		@p2_table_best_user[4][2] = "#{most_placed.count}"
	end

	def top_avg_user
		avg_user = User.find_by_sql "SELECT users.id, users.first_name, users.last_name, AVG(all_orders.revenue) 
										FROM users JOIN 
										(SELECT orders.id AS order_id, orders.user_id AS user_id, SUM(quantity * price) AS revenue 
											FROM users JOIN orders ON users.id = orders.user_id 
											JOIN order_contents ON orders.id = order_contents.order_id 
											JOIN products ON order_contents.product_id = products.id 
											WHERE orders.checkout_date IS NOT NULL 
											GROUP BY orders.id
										) AS all_orders ON users.id = all_orders.user_id 
										GROUP BY users.id ORDER BY avg DESC"
		avg_user[0]
	end

	def top_user_overall
		highest_user = Order.find_by_sql "SELECT users.id, users.first_name, users.last_name, SUM(price * quantity) AS revenue 
										FROM orders JOIN users ON orders.user_id = users.id 
													JOIN order_contents ON order_contents.order_id = orders.id 
													JOIN products ON order_contents.product_id = products.id 
													WHERE checkout_date IS NOT NULL 
													GROUP BY users.id 
													ORDER BY revenue DESC LIMIT 1"
		highest_user[0]
	end

	def most_order_user
		User.joins("JOIN orders ON users.id = orders.user_id")
			.where.not("orders.checkout_date" => nil)
			.group(:id)
			.select("COUNT(*), users.id, users.first_name, users.last_name")
			.order("count" => :desc)
			.first
	end

	def top_order_overall
		highest_order = Order.find_by_sql "SELECT orders.id, orders.user_id, SUM(price * quantity) AS revenue 
											FROM orders JOIN users ON orders.user_id = users.id 
											JOIN order_contents ON order_contents.order_id = orders.id 
											JOIN products ON order_contents.product_id = products.id 
											WHERE checkout_date IS NOT NULL GROUP BY orders.id ORDER BY revenue DESC LIMIT 1"
		highest_order[0]
	end

	def top_4_states 
		Address.select("count(addresses.state_id), states.name").
			joins("JOIN users ON users.billing_id = addresses.id").
			joins("JOIN states ON addresses.state_id = states.id").
			group("states.name").order("count" => :desc).limit(4)
	end

	def top_4_cities 
		Address.select("count(addresses.city_id), cities.name").
			joins("JOIN users ON users.billing_id = addresses.id").
			joins("JOIN cities ON addresses.city_id = cities.id").
			group("cities.name").order("count" => :desc).limit(4)
	end

	def initial_data_p1
		[ ['Item', 'Data'] , ['New Users', '1'], ['Orders', '1'], 
		  ['New Products', '1'], ['Revenue', '1'] ]
	end

	def initial_data_p2
		[ ['Item', 'User', 'Quantity'] , ['New Users', '1', '1'], 
		  ['Orders', '1', '1'], ['Item', 'User', 'Quantity'] , 
		  ['New Users', '1', '1'] ] 

	end

	def populate_panel1_t1
		@p1_table_7     = initial_data_p1
		@p1_table_7[1][1] = User.past_days(7).count
		@p1_table_7[2][1] = Order.past_days(7).count
		@p1_table_7[3][1] = Product.past_days(7).count
		revenue_7 = Order.purchases_period(Time.now - 7.days,Time.now).sum("quantity * price")
		@p1_table_7[4][1] = "$#{revenue_7}"
	end

	def populate_panel1_t2
		@p1_table_30    = initial_data_p1
		@p1_table_30[1][1] = User.past_days(30).count
		@p1_table_30[2][1] = Order.past_days(30).count
		@p1_table_30[3][1] = Product.past_days(30).count
		revenue_30 = Order.purchases_period(Time.now - 30.days,Time.now).sum("quantity * price")
		@p1_table_30[4][1] = "$#{revenue_30}"
	end

	def populate_panel1_t3
		@p1_table_total = initial_data_p1
		@p1_table_total[1][1] = User.count
		@p1_table_total[2][1] = Order.placed.count
		@p1_table_total[3][1] = Product.count
		revenue_total = Order.purchases_all.sum("quantity * price")
		@p1_table_total[4][1] = "$#{revenue_total}"
	end
end