class Order < ActiveRecord::Base

	def self.total_orders(date=nil)

		o = Order.all
		unless date.nil?
			o.where("created_at > ?", date).count
		else
			o.count
		end
	end


	def revenue
		o = Order.joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id").where("checkout_date IS NOT null").count("COUNT(quantity*products.price)")
	end