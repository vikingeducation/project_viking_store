class DashboardController < ApplicationController
  include Accessor

  def index

    # ###############################################################
    # 1. Overall Platform # totals for past 7 days, 30 days, all time

    @users_seven_days = total_users(9)
    @orders_seven_days = total_orders(9)
    @products_seven_days = total_new_products(9)
    @revenue_seven_days = total_revenue(9)

    @users_thirty_days = total_users(30)
    @orders_thirty_days = total_orders(30)
    @products_thirty_days = total_new_products(30)
    @revenue_thirty_days = total_revenue(30)

    #update if database exists in 100 years
    @users_total = total_users(36000)
    @orders_total = total_orders(36000)
    @products_total = total_new_products(36000)
    @revenue_total = total_revenue(36000)

    # #################################
    # 2. User demographics and Behavior

    @top_states = top_three_states
    @top_cities = top_three_cities
    @hsov = highest_single_order_value
    @hlov = highest_lifetime_order_value
    @haov = highest_average_order_value
    @most_orders_placed = most_orders_placed

    # ###############################################################
    # 3. Order statistics # totals for past 7 days, 30 days, all time

    @average_seven_days = average_order_value(9)
    @average_thirty_days = average_order_value(30)
    @average_total = average_order_value(36000)

    @max_seven_days = largest_order_value(9)
    @max_thirty_days = largest_order_value(30)
    @max_total = largest_order_value(36000)

    # ###################
    # 4. Time series data

    @orders_by_day = orders_by_day
    @orders_by_week = orders_by_week

  end

end
