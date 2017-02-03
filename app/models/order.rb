class Order < ApplicationRecord

	belongs_to :user
	belongs_to :customer, :class_name => "User", foreign_key: :user_id
	belongs_to :payment, :class_name => "CreditCard", foreign_key: :credit_card_id
	has_many :order_contents
	has_many :products, 
			 :through => :order_contents
	has_many :categories, 
			 :through => :products

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

	def self.past_days(n)
		Order.where(:checkout_date => (Time.now - n.days)..Time.now)
	end

	def self.placed
		Order.where.not(:checkout_date => nil)
	end

	def self.revenue_table
		Order.joins("JOIN order_contents ON orders.id = order_contents.order_id")
			 .joins("JOIN products ON order_contents.product_id = products.id")
			 .group(:id)
			 .select("orders.id AS order_id, SUM(quantity * price) AS revenue")
			 .order("revenue DESC")
	end
	
end
