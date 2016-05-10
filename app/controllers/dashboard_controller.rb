class DashboardController < ApplicationController
  def index

    # Global Data
    @total_users = User.total
    @total_orders = Order.total
    @total_products = Product.total
    @revenue = Order.revenue
    # 30 days data
    @new_users = User.new_users(30)
    @new_orders = Order.new_orders(30)
    @new_products = Product.new_products(30)
    @revenue_days = Order.revenue_days(30)

    #7 days data
    @new_users_seven = User.new_users(7)
    @new_orders_seven = Order.new_orders(7)
    @new_products_seven = Product.new_products(7)
    @revenue_days_seven = Order.revenue_days(7)

    # top cities and states
    @top_states = State.top_states
    @top_cities = City.top_cities

    # Highest Numbers
    @single_highest_value = User.single_highest_value
    @highest_lifetime_value = User.highest_lifetime_value
    @highest_average_value = User.highest_average_value
    @most_orders_place = User.most_orders_place

    # Order Statistic
    @avg_order_value = Order.avg_order_value
    @largest_order_value = Order.largest_order_value
  end
end
