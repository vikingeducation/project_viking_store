class Order < ActiveRecord::Base

	def self.total_orders(date=nil)

		o = Order.all
		unless date.nil?
			o.where("created_at > ?", date).count
		else
			o.count
		end
	end


	def self.total_revenue(date=nil)
		o = Order.joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id")
		.where("checkout_date IS NOT NULL")

		if date.nil?
			o.sum("quantity * products.price")
		else
			o.where("order_contents.created_at > ?", date).sum("quantity * products.price")
		end
	end

end
