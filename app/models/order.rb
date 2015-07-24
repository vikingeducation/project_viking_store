class Order < ActiveRecord::Base

def self.new_orders(input_day)
	self.where("created_at > ?", input_day.days.ago).count
end

def self.revenue_table(input)
  	# if input is given:
    table = self.where("checkout_date > ?", input.days.ago).joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id") if input
    # if no input, get all orders with checkout date
    table = self.where("checkout_date IS NOT NULL").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id") unless input
    return table
end

def self.revenue(input=nil)
	table = revenue_table(input).select(:order_id, :quantity, :product_id, :price)
	revenue = table.select("round(SUM(quantity * price), 2) AS sum")
	revenue.first[:sum]
end


end
