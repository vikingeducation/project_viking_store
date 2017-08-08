class MainController < ApplicationController

  def index
    @user_created_seven_days = User.user_created_seven_days
    @user_created_thirty_days = User.user_created_thirty_days
    @user_count_total = User.user_count

    @highest_single_order_value = User.highest_single_order_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_order = User.highest_average_order
    @most_orders_placed = User.most_orders_placed

    @order_created_seven_days = Order.order_created_seven_days
    @order_created_thirty_days = Order.order_created_thirty_days
    @order_count = Order.order_count

    @revenue_in_seven_days = Order.revenue_in_seven_days
    @revenue_in_thirty_days = Order.revenue_in_thirty_days
    @total_revenue = Order.total_revenue

    @orders_by_day = Order.orders_by_day
    @orders_by_week = Order.orders_by_week

    @top_three_states = State.top_three_states
    @top_three_cities = City.top_three_cities

    @product_created_seven_days = Product.product_created_seven_days
    @product_created_thirty_days = Product.product_created_thirty_days
    @product_count = Product.product_count
  end

  
end


