class DashboardsController < ApplicationController
  def index
    # Last 7 days
    @new_users_7 = User.new_signups_7
    @new_orders_7 = Order.new_orders_7
    @new_products_7 = Product.new_products_7
    @revenue_7 = OrderContent.new_revenue_7.to_i

    # Last 30 days
    @new_users_30 = User.new_signups_30
    @new_orders_30 = Order.new_orders_30
    @new_products_30 = Product.new_products_30
    @revenue_30 = OrderContent.new_revenue_30.to_i

    # totals
    @total_users = User.total_signups
    @total_orders = Order.total_orders
    @total_products = Product.total_products
    @total_revenue = OrderContent.total_revenue.to_i

    # top 3 States user live in (billing)
    @top_states = State.top_states
    @top_cities = City.top_cities

    # top users
    @top_single_order = Order.top_single_order.first
    @top_value_customer = Order.top_value_customer.first
    @top_avg_order = Order.top_avg_order.first
    @user_with_most_orders = Order.user_with_most_orders.first

    # Order statistics
    @largest_order_value_30 = Order.largest_order_value_30.first
    @largest_order_value_7 = Order.largest_order_value_7.first
  end
end
