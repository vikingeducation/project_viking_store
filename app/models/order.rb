class Order < ActiveRecord::Base

	def self.total_orders(date=nil)

		o = Order.all
		unless date.nil?
			o.where("created_at > ?", date).count
		else
			o.count
		end
	end

end
