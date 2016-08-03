class DashboardsController < ApplicationController
  

  def show
  	@total_users = User.total_users
  	@total_orders = Order.total_orders
  	@total_products = Product.total_products
  	# @total_revenue =
  	@new_month_user = User.total_users(1.month.ago)
  end



end
