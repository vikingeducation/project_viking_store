class DashboardController < ApplicationController
  def index
    @total_users = User.total
    @total_orders = Order.total
    @total_products = Product.total
    @revenue = Order.revenue
    @new_users = User.new_users(30)
    @new_orders = Order.new_orders(30)
    @new_products = Product.new_products(30)
    @revenue_days = Order.revenue_days(30)
  end
end
