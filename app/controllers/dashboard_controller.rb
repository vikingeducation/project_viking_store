class DashboardController < ApplicationController

  def index
    #1. Overall platform stats
    @user_count = User.total
    @order_count = Order.total
    @product_count = Product.total
    @total_revenue = Order.total_revenue

    @user_count_30 = User.new_users(30)
    @order_count_30 = Order.new_orders(30)
    @product_count_30 = Product.new_products(30)
    @revenue_30 = Order.revenue(30)

    @user_count_7 = User.new_users(7)
    @order_count_7 = Order.new_orders(7)
    @product_count_7 = Product.new_products(7)
    @revenue_7 = Order.revenue(7)

    #2. User Demographics and Behavior
    @top_states = User.top_states

    @top_cities = User.top_cities

    @highest_single_order_user = Order.highest_single_order_user
    @highest_lifetime_order_user = Order.highest_lifetime_order_user
    @highest_avg_order_user = Order.highest_avg_order_user
    @most_orders_user = Order.most_orders_user
  end
end
