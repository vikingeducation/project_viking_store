class DashboardController < ApplicationController
  def index
  	@user_seven = User.new_users(7)
  	@user_thirty = User.new_users(30)
  	@user_total = User.all.count
    @avg_value = Order.highest_avg_order_value
  	@order_seven = Order.new_orders(7.days.ago, 0.days.ago)
  	@order_thirty = Order.new_orders(30.days.ago, 0.days.ago)
  	@order_total = Order.all.count
  	@product_seven = Product.new_products(7)
  	@product_thirty = Product.new_products(30)
  	@product_total = Product.all.count
    @revenue_seven = Order.revenue(7.days.ago, 0.days.ago)
    @revenue_thirty = Order.revenue(30.days.ago, 0.days.ago)
    @revenue_total = Order.revenue

    @states = State.get_top_states
    @cities = City.get_top_cities

    @highest_single_order = Order.highest_single_order
    @highest_7day_order = Order.highest_single_order(7.days.ago, 0.days.ago)
    @highest_30day_order = Order.highest_single_order(30.days.ago, 0.days.ago)

    @lifetime_value = Order.lifetime_value

    @avg_total_value = Order.avg_value_by_time
    @avg_7day_value = Order.avg_value_by_time(7)
    @avg_30day_value = Order.avg_value_by_time(30)

    @most_orders = Order.most_orders_placed

    #---------- Time Series Data
    #---------- Orders by day
    @order_today = Order.new_orders(1.days.ago, 0.days.ago)
    @revenue_today = Order.revenue(1.days.ago, 0.days.ago)
    @order_yesterday = Order.new_orders(2.days.ago, 1.days.ago)
    @revenue_yesterday = Order.revenue(2.days.ago, 1.days.ago)
    @order_2_days_ago = Order.new_orders(3.days.ago, 2.days.ago)
    @revenue_2_days_ago = Order.revenue(3.days.ago, 2.days.ago)
    @order_3_days_ago = Order.new_orders(4.days.ago, 3.days.ago)
    @revenue_3_days_ago = Order.revenue(4.days.ago, 3.days.ago)
    @order_4_days_ago = Order.new_orders(5.days.ago, 4.days.ago)
    @revenue_4_days_ago = Order.revenue(5.days.ago, 4.days.ago)
    @order_5_days_ago = Order.new_orders(6.days.ago, 5.days.ago)
    @revenue_5_days_ago = Order.revenue(6.days.ago, 5.days.ago)
    @order_6_days_ago = Order.new_orders(7.days.ago, 6.days.ago)
    @revenue_6_days_ago = Order.revenue(7.days.ago, 6.days.ago)
    #---------- Orders by week
    @order_this_week = Order.new_orders(7.days.ago, 0.days.ago)
    @revenue_this_week = Order.revenue(7.days.ago, 0.days.ago)
    @order_last_week = Order.new_orders(14.days.ago, 7.days.ago)
    @revenue_last_week = Order.revenue(14.days.ago, 7.days.ago)
    @order_3_last_week = Order.new_orders(21.days.ago, 14.days.ago)
    @revenue_3_last_week = Order.revenue(21.days.ago, 14.days.ago)
    @order_4_last_week = Order.new_orders(28.days.ago, 21.days.ago)
    @revenue_4_last_week = Order.revenue(28.days.ago, 21.days.ago)
    @order_5_last_week = Order.new_orders(35.days.ago, 28.days.ago)
    @revenue_5_last_week = Order.revenue(35.days.ago, 28.days.ago)
    @order_6_last_week = Order.new_orders(42.days.ago, 35.days.ago)
    @revenue_6_last_week = Order.revenue(42.days.ago, 35.days.ago)
    @order_7_last_week = Order.new_orders(49.days.ago, 42.days.ago)
    @revenue_7_last_week = Order.revenue(49.days.ago, 42.days.ago)
  end

  def show
  end
end
