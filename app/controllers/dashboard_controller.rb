class DashboardController < ApplicationController

  def index
    @users = User.all
    @orders = Order.all
    @products = Product.all

    @revenue_last_30 = Order.revenue_ago(30).first.price
    @revenue_last_7 = Order.revenue_ago(7).first.price
    @revenue = Order.revenue.first.price

    @users_last_30 = User.count_last_30
    @users_last_7 = User.count_last_7

    @orders_count_last_30 = Order.count_last(30)
    @orders_count_last_7 = Order.count_last(7)

    @products_count_last_30 = Product.count_last(30)
    @products_count_last_7 = Product.count_last(7)

    @top_three_states = Order.top_state_orders 
    @top_three_cities = Order.top_city_orders
  end
end
