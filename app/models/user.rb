class User < ApplicationRecord
	has_many :cards, class_name: "CreditCard", foreign_key: :user_id, dependent: :destroy
	has_many :orders, dependent: :nullify
	has_many :addresses, dependent: :nullify
	has_many :order_contents,
			 :through => :orders
	has_many :products, 
			 :through => :order_contents

	validates 	:first_name, :last_name, :email,
				:presence => true,
            	:length =>{ :in => 1..64 }

    validates	:email, :format => { :with => /@/ }

    before_destroy :remove_carts

    def default_billing_address
    	Address.find(self.billing_id)
    end

    def default_shipping_address
    	Address.find(self.shipping_id)
    end

    def has_cart?
    	(self.orders.where(:checkout_date => nil).count != 0)
    end

    def remove_carts
    	carts = self.orders.where(:checkout_date => nil)
    	carts.each do |cart|
    		cart.destroy
    	end
    end

    def last_order
    	self.orders.where.not(:checkout_date => nil).order(:checkout_date).limit(1)[0]
    end

	def self.get_past_week
		User.get_past_days(7)
	end

	def self.get_past_month
		User.get_past_days(30)
	end

	def self.get_past_days(n)
		User.where(:created_at => (Time.now - n.days)..Time.now).count
	end

	def self.top_avg_user
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

	def self.top_user_overall
		highest_user = Order.find_by_sql "SELECT users.id, users.first_name, users.last_name, SUM(price * quantity) AS revenue 
										FROM orders JOIN users ON orders.user_id = users.id 
													JOIN order_contents ON order_contents.order_id = orders.id 
													JOIN products ON order_contents.product_id = products.id 
													WHERE checkout_date IS NOT NULL 
													GROUP BY users.id 
													ORDER BY revenue DESC LIMIT 1"
		highest_user[0]
	end

	def self.most_order_user
		User.joins("JOIN orders ON users.id = orders.user_id")
			.where.not("orders.checkout_date" => nil)
			.group(:id)
			.select("COUNT(*), users.id, users.first_name, users.last_name")
			.order("count" => :desc)
			.first
	end

	def self.get_best_order_user(id)
		User.find(id)
	end

end