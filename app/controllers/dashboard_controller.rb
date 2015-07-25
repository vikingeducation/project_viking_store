class DashboardController < ApplicationController
  def index
  	@user_seven = User.new_users(7)
  	@user_thirty = User.new_users(30)
  	@user_total = User.all.count
  	@order_seven = Order.new_orders(7)
  	@order_thirty = Order.new_orders(30)
  	@order_total = Order.all.count
  	@product_seven = Product.new_products(7)
  	@product_thirty = Product.new_products(30)
  	@product_total = Product.all.count
    @revenue_seven = Order.revenue(7)
    @revenue_thirty = Order.revenue(30)
    @revenue_total = Order.revenue

    @states = State.get_top_states
    @cities = City.get_top_cities

    @highest_single_order = Order.highest_single_order
    @highest_7day_order = Order.highest_single_order(7)
    @highest_30day_order = Order.highest_single_order(30)

    @lifetime_value = Order.lifetime_value

    @avg_value = Order.avg_value
    @avg_7day_value = Order.avg_value(7)
    @avg_30day_value = Order.avg_value(30)

    @most_orders = Order.most_orders_placed

  end

  def show
  end
end
