class DashboardsController < ApplicationController


  def show
  	@total_users = User.total_users
  	@total_orders = Order.total_orders
  	@total_products = Product.total_products

    @new_week_users = User.total_users(1.week.ago)
    @new_week_orders = Order.total_orders(1.week.ago)
    @new_week_products = Product.total_products(1.week.ago)
  	# @total_revenue =
  	@new_month_users = User.total_users(1.month.ago)
    @new_month_orders = Order.total_orders(1.month.ago)
    @new_month_products = Product.total_products(1.month.ago)
  end



end
