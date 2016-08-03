class User < ActiveRecord::Base

	def self.total_users(date=nil)

		t = User.all
		unless date.nil?
			t.where("created_at > ?", date).count
		else
			t.count
		end
	end

	def highest_order
		o = Order.joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN users ON users.id = orders.user_id").joins("JOIN products ON order_contents.product_id = products.id").group(:order_id, :price, :first_name, :last_name).select("users.first_name, users.last_name, SUM(price * quantity) AS order_cost")
	end



end
