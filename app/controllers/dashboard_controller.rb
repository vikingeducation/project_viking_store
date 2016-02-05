class DashboardController < ApplicationController
  def index
    @num_total_orders = Order.total_orders_submitted
    @total_revenue = Order.total_revenue_generated

    @users_30 = User.new_users_in_last_n_days( 30 )
    @orders_30 = Order.num_orders_submitted_in_last_n_days( 30 )
    @products_30 = Product.total_products_in_last_n_days( 30 )
    @revenue_30 = Order.revenue_n_days( 30 )

    @users_7 = User.new_users_in_last_n_days( 7 )
    @orders_7 = Order.num_orders_submitted_in_last_n_days( 7 )
    @products_7 = Product.total_products_in_last_n_days( 7 )
    @revenue_7 = Order.revenue_n_days( 7 )

    @top_states = User.top_states
    @top_cities = User.top_cities

    @user_highest_single_order = User.highest_single_order[0]
    @user_highest_lifetime_value = User.highest_lifetime_value[0]
    @user_highest_average_value = User.highest_average_value[0]
    @user_most_orders = User.user_most_orders[0]

    @highest_single_order = Order.largest_order[0].largest_order
    @average_order_value = Order.average_order[0].average_order

    @highest_single_order_7 = Order.largest_order_last_n_days(7)[0].largest_order
    @average_order_value_7 =  Order.average_order_last_n_days(7)[0].average_order

    @average_order_value_30 = @highest_single_order_30 = Order.largest_order_last_n_days(30)[0].largest_order
    @average_order_value_30 = Order.average_order_last_n_days(30)[0].average_order

    ####### last week

    @num_orders_past_n_days = Order.num_orders_past_n_days(7)
    @revenue_past_n_days = Order.revenue_past_n_days(7)

    #######  last 7 weeks

    @num_orders_past_n_weeks = Order.num_orders_past_n_weeks(7)
    @revenue_past_n_weeks = Order.revenue_past_n_weeks(7)

  end
end

# There is a table for total order stats
# field: Number of orders
# field: Revenue generated
# field: Average order value
# field: Largest order value
