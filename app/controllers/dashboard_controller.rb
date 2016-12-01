class DashboardController < ApplicationController
  include Accessor
  def index
    @users_seven_days = total_users(7)
    @orders_seven_days = total_orders(7)
    @products_seven_days = total_new_products(7)
    @revenue_seven_days = total_revenue(7)

    @users_thirty_days = total_users(30)
    @orders_thirty_days = total_orders(30)
    @products_thirty_days = total_new_products(30)
    @revenue_thirty_days = total_revenue(30)

    #update if database exists in 100 years
    @users_all_time = total_users(36000)
    @orders_all_time = total_orders(36000)
    @products_all_time = total_new_products(36000)
    @revenue_all_time = total_revenue(36000)

    @top_states = top_three_states

    @top_cities = top_three_cities

    @hsov = highest_user_order_value
    @hlv = highest_lifetime_value

    @hao = highest_avg_order_value
    @most_placed = most_orders_placed

    @average_seven_days = average_order_value(7)
    @average_thirty_days = average_order_value(30)
    @average_all_time = average_order_value(36000)

    @max_seven_days = largest_order_value(7)
    @max_thirty_days = largest_order_value(30)
    @max_all_time = largest_order_value(36000)


  end


end
