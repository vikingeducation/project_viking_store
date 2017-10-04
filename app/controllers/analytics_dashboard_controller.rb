class AnalyticsDashboardController < ApplicationController
  def index
    @new_users_7 = User.signed_up_in_last 7
    @orders_7 = Order.placed_in_last 7
    @new_products_7 = Product.listed_in_last 7
    @revenue_7 = Order.revenue_since 7

    @new_users_30 = User.signed_up_in_last 30
    @orders_30 = Order.placed_in_last 30
    @new_products_30 = Product.listed_in_last 30
    @revenue_30 = Order.revenue_since 30

    @users_total = User.all
    @orders_total = Order.all
    @products_total = Product.all
    @revenue = Order.revenue

    @top_states = State.most_lived_in(3)
    @top_cities = City.most_lived_in(3)

    @top_orderer = User.with_most_orders
    @max_order = User.with_largest_order
    @biggest_spender = User.highest_value_by_revenue
    @largest_avg_orderer = User.highest_average_order

    @average_order_7 = Order.average_total_since 7
    @largest_order_7 = Order.largest_total_since 7

    @average_order_30 = Order.average_total_since 30
    @largest_order_30 = Order.largest_total_since 30
  end
end
