class Order < ActiveRecord::Base

def self.new_orders(input_day)
	self.where("created_at > ?", input_day.days.ago).count
end

def self.revenue_table(input)

	# if input is given:
  table = self.where("checkout_date > ?", input.days.ago)
              .joins("JOIN order_contents ON orders.id = order_contents.order_id")
              .joins("JOIN products ON products.id = order_contents.product_id") if input
  # if no input, get all orders with checkout date
  table = self.where("checkout_date IS NOT NULL")
              .joins("JOIN order_contents ON orders.id = order_contents.order_id")
              .joins("JOIN products ON products.id = order_contents.product_id") unless input
  return table.select(:order_id, :quantity, :product_id, :price)
end

def self.revenue(input=nil)
	table = revenue_table(input)
	revenue = table.select("round(SUM(quantity * price), 2) AS sum")
	revenue.first[:sum]
end

def self.best(input=nil)
  table = revenue_table(input)
  revenue = table.select("round(MAX(quantity * price), 2) AS max, orders.user_id AS user")
  users = revenue.joins("JOIN users ON user_id = users.id").select("users.first_name, users.last_name")
  [revenue.first[:max], "#{users.first[:first_name]} #{users.first[:last_name]}"]
end

def self.lifetime_value(input=nil)
  table = revenue_table(input)
  revenue = table.select("round(SUM(quantity * price), 2) AS sum").group(:user_id).order("sum DESC")
  revenue.first
end




end
