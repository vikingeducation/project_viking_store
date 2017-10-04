class AnalyticsDashboardController < ApplicationController
  def index
    @new_users_7 = User.signed_up_since 7.days.ago
    @orders_7 = Order.placed_since 7.days.ago
    @new_products_7 = Product.listed_since 7.days.ago
    @revenue_7 = Order.revenue_since 7.days.ago

    @new_users_30 = User.signed_up_since 30.days.ago
    @orders_30 = Order.placed_since 30.days.ago
    @new_products_30 = Product.listed_since 30.days.ago
    @revenue_30 = Order.revenue_since 30.days.ago

    @users = User.all
    @orders = Order.all
    @products = Product.all
    @revenue = Order.revenue

    @top_states = State.most_lived_in(3)
    @top_cities = City.most_lived_in(3)

    @top_orderer = User.with_most_orders
    @max_order = User.with_largest_order
    @biggest_spender = User.highest_value_by_revenue
    @largest_avg_orderer = User.highest_average_order

    @average_order_7 = Order.average_total_since 7.days.ago
    @largest_order_7 = Order.largest_total_since 7.days.ago

    @average_order_30 = Order.average_total_since 30.days.ago
    @largest_order_30 = Order.largest_total_since 30.days.ago

    @average_order = Order.average_total
    @largest_order = 'TBD'
  end
end
