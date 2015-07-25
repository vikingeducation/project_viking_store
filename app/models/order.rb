class Order < ActiveRecord::Base

def self.new_orders(start_day, end_day)
	self.where("checkout_date > ? AND checkout_date < ?", start_day, end_day).count
end

def self.revenue_table(start_day=99999999.days.ago, end_day=0.days.ago)
	# if input is given:
  table = self.where("checkout_date > ? AND checkout_date < ?", start_day, end_day).joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id")
  # if no input, get all orders with checkout date
  # table = self.where("checkout_date IS NOT NULL").joins("JOIN order_contents ON orders.id = order_contents.order_id").joins("JOIN products ON products.id = order_contents.product_id") unless input
  return table.select(:order_id, :quantity, :product_id, :price)
end

def self.revenue(start_day=99999999.days.ago, end_day=0.days.ago)
	table = revenue_table(start_day, end_day)
	revenue = table.select("round(SUM(quantity * price), 2) AS sum")
	revenue.first[:sum]
end

def self.highest_single_order(start_day=99999999.days.ago, end_day=0.days.ago)
  table = revenue_table(start_day, end_day)
  revenue_table = table.select("round(SUM(quantity * price), 2) AS sum").group(:order_id).order("sum desc")
  users_revenue = revenue_table.joins("JOIN users ON user_id = users.id").select("users.first_name, users.last_name")
  [revenue_table.first[:sum], "#{users_revenue.first[:first_name]} #{users_revenue.first[:last_name]}"]
end

def self.lifetime_value(start_day=99999999.days.ago, end_day=0.days.ago)
  table = revenue_table(start_day, end_day)
  revenue_table = table.select("round(SUM(quantity * price), 2) AS sum").group(:user_id).order("sum desc")
  users_revenue = revenue_table.joins("JOIN users ON user_id = users.id").select("users.first_name, users.last_name")
  [revenue_table.first[:sum], "#{users_revenue.first[:first_name]} #{users_revenue.first[:last_name]}"]
end

def self.avg_value(input=99999999)

  table = Order.find_by_sql(["  SELECT first_name, last_name, AVG(total) AS average
                                FROM(
                                SELECT users.first_name, users.last_name, orders.id, product_id, SUM(quantity * price) AS total, user_id FROM orders
                                JOIN order_contents ON orders.id = order_contents.order_id
                                JOIN products ON products.id = order_contents.product_id
                                JOIN users ON user_id = users.id
                                WHERE orders.checkout_date > ?
                                GROUP BY orders.id
                                ORDER BY user_id
                                )
                                GROUP BY user_id
                                ORDER BY average desc
                                LIMIT 1", input.days.ago])

  return [table[0][:average], "#{table[0][:first_name]} #{table[0][:last_name]}"]

end


def self.avg_value_by_time(input=99999999)
  table = Order.find_by_sql(["
                                SELECT users.first_name, users.last_name, orders.id, product_id, SUM(quantity * price) AS total, user_id FROM orders
                                JOIN order_contents ON orders.id = order_contents.order_id
                                JOIN products ON products.id = order_contents.product_id
                                JOIN users ON user_id = users.id
                                WHERE orders.checkout_date > ?
                                GROUP BY orders.id
                                ORDER BY user_id
                                ", input.days.ago])

  total = table.inject(0) {|sum, val| sum + val[:total]}
  avg = total/table.length
end

def self.most_orders_placed(input=nil)
  table = Order.select("COUNT(orders.id) AS counter, users.first_name, users.last_name")
              .joins("JOIN users ON users.id = orders.user_id")
              .where("orders.checkout_date IS NOT NULL")
              .group("users.id")
              .order("counter desc")
              .limit(1)
  return [table[0][:counter], "#{table[0][:first_name]} #{table[0][:last_name]}"]
end



end
