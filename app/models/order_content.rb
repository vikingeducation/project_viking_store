class OrderContent < ActiveRecord::Base

  belongs_to :order
  belongs_to :product

	def self.revenue(time)
		OrderContent.joins(
			"JOIN orders ON orders.id  = order_contents.order_id").
			where('orders.placed_at > ?',time).
			select("quantity*current_price AS revenue").
			map(&:revenue).inject(&:+)
	end

	def self.highest_first
		User.find(OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).select("user_id, quantity*current_price AS revenue").order("revenue DESC")[0].user_id).first_name
	end

	def self.highest_last
		User.find(OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).select("user_id, quantity*current_price AS revenue").order("revenue DESC")[0].user_id).last_name
	end

	def self.highest_single_value
  	OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).select("quantity*current_price AS revenue").order("revenue DESC")[0].revenue.round(2)  # figure out for two decimals
  end

  def self.highest_lifetime
  	OrderContent.joins("JOIN orders ON orders.id = order_contents.order_id").where('orders.is_placed = ?',true).select("user_id, SUM(quantity*current_price) AS revenue").group(:user_id).order("revenue DESC")[0].revenue.round(2)
  end

  def self.highest_lifetime_first
    User.find(OrderContent.joins("JOIN orders ON orders.id = order_contents.order_id").
      where('orders.is_placed = ?',true).
      select("user_id, SUM(quantity*current_price) AS revenue").
      group(:user_id).order("revenue DESC")[0].user_id).first_name
  end

  def self.highest_lifetime_last
    User.find(OrderContent.joins("JOIN orders ON orders.id = order_contents.order_id").
      where('orders.is_placed = ?',true).
      select("user_id, SUM(quantity*current_price) AS revenue").
      group(:user_id).order("revenue DESC")[0].user_id).last_name
  end

  def self.highest_average
  
  #############
    @highest_average = OrderContent.
      joins("JOIN orders ON orders.id  = order_contents.order_id").
      where('orders.is_placed = ?',true).
      group(:user_id).
      select("user_id, (SUM(quantity*current_price))/ (COUNT(user_id)) AS average").
      order("average DESC")[0].average

    @highest_average_first = User.find(OrderContent.
      joins("JOIN orders ON orders.id  = order_contents.order_id").
      where('orders.is_placed = ?',true).
      group(:user_id).
      select("user_id, (SUM(quantity*current_price))/ (COUNT(user_id)) AS average").
      order("average DESC")[0].user_id).first_name

    @highest_average_last = User.find(OrderContent.
      joins("JOIN orders ON orders.id  = order_contents.order_id").
      where('orders.is_placed = ?',true).
      group(:user_id).
      select("user_id, (SUM(quantity*current_price))/ (COUNT(user_id)) AS average").
      order("average DESC")[0].user_id).last_name

    [@highest_average, @highest_average_first, @highest_average_last]
    
  end

  def self.largest_order(time) #panel 3 largest order
    OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ? AND orders.placed_at > ?',true, time).select("quantity*current_price AS revenue").order("revenue DESC")[0].revenue
  end

  def self.most_orders_placed
    count = @user_first = OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).group(:user_id).select("COUNT(order_id) AS count_orders,user_id").order("count_orders DESC")[0].count_orders
    @user_first = User.find(OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).group(:user_id).select("COUNT(order_id) AS count_orders,user_id").order("count_orders DESC")[0].user_id).first_name
    @user_last = User.find(OrderContent.joins("JOIN orders ON orders.id  = order_contents.order_id").where('orders.is_placed = ?',true).group(:user_id).select("COUNT(order_id) AS count_orders,user_id").order("count_orders DESC")[0].user_id).last_name
    [count,@user_first,@user_last]
  end


end
