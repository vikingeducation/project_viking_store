class DashboardsController < ApplicationController


  def show
  	@total_users = User.total_users
  	@total_orders = Order.total_orders
  	@total_products = Product.total_products
    @total_revenue = Order.total_revenue

    @new_week_users = User.total_users(1.week.ago)
    @new_week_orders = Order.total_orders(1.week.ago)
    @new_week_products = Product.total_products(1.week.ago)
    @new_week_revenue = Order.total_revenue(1.week.ago)

  	@new_month_users = User.total_users(1.month.ago)
    @new_month_orders = Order.total_orders(1.month.ago)
    @new_month_products = Product.total_products(1.month.ago)
    @new_month_revenue = Order.total_revenue(1.month.ago)


    @top_states = State.top_states(3)
    @top_cities = City.top_cities(3)
  end



end
