class DashboardsController < ApplicationController
  def index
    @users_last_seven =  User.in_the_last_seven_days
    @orders_last_seven = Order.in_the_last_seven_days
    @products_last_seven = Product.in_the_last_seven_days
    @revenue_last_seven = Order.revenue_in_the_last_seven_days

    @users_last_thirty = User.in_the_last_thirty_days
    @orders_last_thirty = Order.in_the_last_thirty_days
    @products_last_thirty = Product.in_the_last_thirty_days
    @revenue_last_thirty = Order.revenue_in_the_last_thirty_days

    @total_orders = Order.total_orders
    @total_revenue = Order.total_revenue

    @top_three_states = User.states_by_shipping_address
    @top_three_cities = User.cities_by_shipping_address
    @highest_single_order_value = User.highest_single_order_value
  end
end
