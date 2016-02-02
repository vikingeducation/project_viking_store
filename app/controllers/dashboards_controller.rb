class DashboardsController < ApplicationController
  def index
    @num_total_users = User.total_users
    @num_total_products = Product.total_products_listed
    @num_total_orders = Order.total_orders_submitted
    @total_revenue = Order.total_revenue_generated

    @users_30 = User.new_users_30
    @orders_30 = Order.orders_submitted_30
    @products_30 = Product.total_products_30
    @revenue_30 = Order.revenue_30
  end
end

# There is a table for "Last 30 Days" data in Panel 1
# Field: New users who signed up
# Field: Orders placed
# Field: New Products added to the listing
# Field: Revenue during the period
