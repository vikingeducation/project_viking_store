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

    @new_users_seven = User.new_users(7)
    @new_orders_seven = Order.new_orders(7)
    @new_products_seven = Product.new_products(7)
    @revenue_days_seven = Order.revenue_days(7)


  end
end
