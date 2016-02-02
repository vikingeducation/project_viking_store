class DashboardsController < ApplicationController
  def index
    @num_total_users = User.total_users
    @num_total_products = Product.total_products_listed
    @num_total_orders = Order.total_orders_submitted
    @total_revenue = Order.total_revenue_generated
  end
end
