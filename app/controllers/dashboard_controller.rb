class DashboardController < ApplicationController

  def index
    @total_users = User.all.count
    @total_orders = Order.all.count
    @total_products = Product.all.count
    @total_revenue = OrderContent.new.total_revenue_since_days_ago(100000)
    @users_last_thirty_days = User.new.created_since_days_ago(30)
    @orders_last_thirty_days = Order.new.created_since_days_ago(30)
    @products_last_thirty_days = Product.new.created_since_days_ago(30)
    @total_revenue_last_thirty_days = OrderContent.new.total_revenue_since_days_ago(30)
    @users_last_seven_days = User.new.created_since_days_ago(7)
    @orders_last_seven_days = Order.new.created_since_days_ago(7)
    @products_last_seven_days = Product.new.created_since_days_ago(7)
    @total_revenue_last_seven_days = OrderContent.new.total_revenue_since_days_ago(7)
  end

end
