class DashboardController < ApplicationController

  def index
    @total_users = User.all.count
    @total_orders = Order.all.count
    @total_products = Product.all.count
    @total_revenue = OrderContent.total_revenue_since_days_ago(100000)
    @users_last_thirty_days = User.created_since_days_ago(30)
    @orders_last_thirty_days = Order.created_since_days_ago(30)
    @products_last_thirty_days = Product.created_since_days_ago(30)
    @total_revenue_last_thirty_days = OrderContent.total_revenue_since_days_ago(30)
    @users_last_seven_days = User.created_since_days_ago(7)
    @orders_last_seven_days = Order.created_since_days_ago(7)
    @products_last_seven_days = Product.created_since_days_ago(7)
    @total_revenue_last_seven_days = OrderContent.total_revenue_since_days_ago(7)
  end

end
