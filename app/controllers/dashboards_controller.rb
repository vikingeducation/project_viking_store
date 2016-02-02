class DashboardsController < ApplicationController
  def index
    @num_total_users = User.total_users
    @num_total_products = Product.total_products_listed
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

    # @user_highest_single_order
    @user_highest_lifetime_value = User.highest_lifetime_value
    # @user_highest_avergae_value
    # @user_most_orders

  end
end

# There is a table for "Last 30 Days" data in Panel 1
# Field: New users who signed up
# Field: Orders placed
# Field: New Products added to the listing
# Field: Revenue during the period
