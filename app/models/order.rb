class Order < ApplicationRecord

	belongs_to :user
	belongs_to :customer, :class_name => "User", foreign_key: :user_id
	belongs_to :payment, :class_name => "CreditCard", foreign_key: :credit_card_id
	has_many :order_contents, :dependent => :destroy
	has_many :products, 
			 :through => :order_contents
	has_many :categories, 
			 :through => :products

	def value
		self.order_contents.joins(:product).sum("quantity * price").to_f
	end

	def self.purchases_period(a, b)
		Order.joins("JOIN order_contents ON orders.id = order_contents.order_id")
			 .joins("JOIN products ON order_contents.product_id = products.id")
			 .where(:checkout_date => a..b)
	end

	def self.purchases_all
		Order.joins("JOIN order_contents ON orders.id = order_contents.order_id")
			 .joins("JOIN products ON order_contents.product_id = products.id")
			 .where.not(:checkout_date => nil)
	end

	def self.get_past_week
		Order.get_past_days(7)
	end

	def self.get_past_month
		Order.get_past_days(30)
	end

	def self.get_past_days(n)
		Order.where(:checkout_date => (Time.now - n.days)..Time.now).count
	end

	def self.placed
		Order.where.not(:checkout_date => nil)
	end

	def self.get_past_n_days_revenue(n)
		Order.purchases_period(Time.now - n.days,Time.now).sum("quantity * price")
	end

	def self.get_past_week_revenue
		Order.get_past_n_days_revenue(7)
	end

	def self.get_past_month_revenue
		Order.get_past_n_days_revenue(30)
	end

	def self.get_total_revenue
		Order.purchases_all.sum("quantity * price")
	end

	def self.revenue_table
		Order.joins("JOIN order_contents ON orders.id = order_contents.order_id")
			 .joins("JOIN products ON order_contents.product_id = products.id")
			 .group(:id)
			 .select("orders.id AS order_id, SUM(quantity * price) AS revenue")
			 .order("revenue DESC")
	end

	def self.top_order_overall
		highest_order = Order.find_by_sql "SELECT orders.id, orders.user_id, SUM(price * quantity) AS revenue 
											FROM orders JOIN users ON orders.user_id = users.id 
											JOIN order_contents ON order_contents.order_id = orders.id 
											JOIN products ON order_contents.product_id = products.id 
											WHERE checkout_date IS NOT NULL GROUP BY orders.id ORDER BY revenue DESC LIMIT 1"
		highest_order[0]
	end

	def self.get_average_order_past_days(n)
		t1 = Time.now - n.days
		t2 = Time.now

		average_of_orders = Order.find_by_sql "SELECT AVG(revenue) FROM 
								(SELECT orders.id AS order_id, SUM(quantity * price) AS revenue 
									FROM orders JOIN order_contents ON orders.id = order_contents.order_id 
									JOIN products ON order_contents.product_id = products.id 
									WHERE checkout_date BETWEEN '#{t1}' AND '#{t2}' GROUP BY orders.id) AS average_table"
	end

	def self.get_average_order_past_week
		Order.get_average_order_past_days(7)
	end

	def self.get_average_order_past_month
		Order.get_average_order_past_days(30)
	end

	def self.get_average_order

		Order.find_by_sql "SELECT AVG(revenue) FROM 
								(SELECT orders.id AS order_id, SUM(quantity * price) AS revenue 
									FROM orders JOIN order_contents ON orders.id = order_contents.order_id 
									JOIN products ON order_contents.product_id = products.id 
									WHERE checkout_date IS NOT NULL GROUP BY orders.id) AS average_table"
	end

	def self.get_past_days_table(n)
		table = Array.new(5) { Array.new }
		table[0][0] = 'Item'
		table[0][1] = 'Data'
		table[1][0] = 'Number of Orders'
		table[2][0] = 'Total Revenue'
		table[3][0] = 'Average Order Value'
		table[4][0] = 'Largest Order Value'
		table[1][1] = "#{Order.get_past_week}"
		table[2][1] = "$#{Order.get_past_week_revenue}"
		average_of_orders = get_average_order_past_week
		table[3][1] = "$#{average_of_orders[0].avg.to_f.round(2)}"
		largest_order = Order.revenue_table.where(:checkout_date => Time.now - n.days..Time.now).limit(1)[0].revenue.to_f
		table[4][1] = "$#{largest_order}"
		table
	end

	def self.get_past_week_table
		get_past_days_table(7)
	end

	def self.get_past_month_table
		get_past_days_table(30)
	end

	def self.get_overall_table
		table = Array.new(5) { Array.new }
		table[0][0] = 'Item'
		table[0][1] = 'Data'
		table[1][0] = 'Number of Orders'
		table[2][0] = 'Total Revenue'
		table[3][0] = 'Average Order Value'
		table[4][0] = 'Largest Order Value'
		table[1][1] = "#{Order.placed.count}"
		table[2][1] = "$#{Order.get_total_revenue}"

		average_of_orders = get_average_order

		table[3][1] = "$#{average_of_orders[0].avg.to_f.round(2)}"

		largest_order = Order.revenue_table.where.not(:checkout_date => nil).limit(1)[0].revenue.to_f
		table[4][1] = "$#{largest_order}"
		table
	end
end
