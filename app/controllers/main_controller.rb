class MainController < ApplicationController

  def index
    @user_created_seven_days = User.user_created(7)
    @user_created_thirty_days = User.user_created(30)
    @user_count_total = User.user_count

    @highest_single_order_value = User.highest_single_order_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_order = User.highest_average_order
    @most_orders_placed = User.most_orders_placed

    @order_created_seven_days = Order.order_created(7)
    @order_created_thirty_days = Order.order_created(30)
    @order_count = Order.order_count

    @revenue_in_seven_days = Order.revenue_created(7)
    @revenue_in_thirty_days = Order.revenue_created(30)
    @total_revenue = Order.total_revenue
    
    @product_created_seven_days = Product.product_created(7)
    @product_created_thirty_days = Product.product_created(30)
    @product_count = Product.product_count

    @average_order_in_seven_days = Order.average_order(7)
    @average_order_in_thirty_days = Order.average_order(30)
    @average_order = Order.avg_order

    @max_order_in_seven_days = Order.max_order(7)
    @max_order_in_thirty_days = Order.max_order(30)
    @max_order = Order.max_ord

    @orders_by_day = Order.orders_by_day
    @orders_by_week = Order.orders_by_week

    @top_three_states = State.top_three_states
    @top_three_cities = City.top_three_cities

  end

  
end


