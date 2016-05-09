class DashboardController < ApplicationController
  def index
    @total_users = User.total
    @total_orders = Order.total
    @total_products = Product.total
    @revenue = Order.revenue
  end
end
