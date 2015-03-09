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
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_order_value = User.highest_average_order_value
    @most_orders_placed = User.most_orders_placed

    @average_order_value_seven = Order.average_order_value_seven
    @average_order_value_thirty = Order.average_order_value_thirty
    @average_order_value_all = Order.average_order_value_all

    @largest_order_value_seven = Order.largest_order_value_seven
    @largest_order_value_thirty = Order.largest_order_value_thirty
    @largest_order_value_all = Order.largest_order_value_all

    @recent_week = Order.quantity_of_orders_last_week(0)
    @one_week_ago = Order.quantity_of_orders_last_week(1)
    @two_weeks_ago = Order.quantity_of_orders_last_week(2)
    @three_weeks_ago = Order.quantity_of_orders_last_week(3)
    @four_weeks_ago = Order.quantity_of_orders_last_week(4)
    @five_weeks_ago = Order.quantity_of_orders_last_week(5)
    @six_weeks_ago = Order.quantity_of_orders_last_week(6)

    @recent_day = Order.quantity_of_orders_by_day(0)
    @one_day_ago = Order.quantity_of_orders_by_day(1)
    @two_days_ago = Order.quantity_of_orders_by_day(2)
    @three_days_ago = Order.quantity_of_orders_by_day(3)
    @four_days_ago = Order.quantity_of_orders_by_day(4)
    @five_days_ago = Order.quantity_of_orders_by_day(5)
    @six_days_ago = Order.quantity_of_orders_by_day(6)
    render layout: "admin"
    
    end
end
