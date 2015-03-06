class DashboardsController < ApplicationController

  def index
    @users_last_seven =  User.new_since 7.days.ago
    @orders_last_seven = Order.checked_out_since 7.days.ago
    @products_last_seven = Product.in_the_last_seven_days
    @revenue_last_seven = Order.revenue_since 7.days.ago

    @users_last_thirty = User.new_since 30.days.ago
    @orders_last_thirty = Order.checked_out_since 30.days.ago
    @products_last_thirty = Product.in_the_last_thirty_days
    @revenue_last_thirty = Order.revenue_since 30.days.ago

    @total_orders = Order.total_orders
    @total_revenue = Order.total_revenue

    @top_three_states = User.states_by_shipping_address
    @top_three_cities = User.cities_by_shipping_address

    @highest_single_order_value = User.highest_single_order_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_order_value = User.highest_average_order_value
    @most_orders_placed = User.most_orders_placed

    @average_order_value_seven = Order.average_order_value_since 7.days.ago
    @average_order_value_thirty = Order.average_order_value_since 30.days.ago
    @average_order_value_all = Order.average_order_value_all

    @largest_order_value_seven = Order.largest_order_value_since 7.days.ago
    @largest_order_value_thirty = Order.largest_order_value_since 30.days.ago
    @largest_order_value_all = Order.largest_order_value_ever

    @orders_by_day = Order.time_series_by_day
    @orders_by_week = Order.time_series_by_week
  end
end
