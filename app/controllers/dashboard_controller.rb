class DashboardController < ApplicationController
  def index
    # week
    @new_users_week = User.created_since 7.days.ago
    @orders_week = Order.placed_since 7.days.ago
    @revenue_week = Order.revenue_since 7.days.ago

    # month
    @new_users_month = User.created_since 30.days.ago
    @orders_month = Order.placed_since 30.days.ago
    @revenue_month = Order.revenue_since 30.days.ago

    # totals
    @users_total = User.total
    @orders_total = Order.total
    @products_total = Product.total
    @revenue_total = Order.total_revenue

    # top 3s
    @top_states = User.top_3_billing_states
    @top_cities = User.top_3_billing_cities

    # user awards
    @highest_single_order = User.highest_single_order
    @highest_lifetime = User.highest_lifetime_value
    @highest_avg_order = User.highest_avg_order
    @most_orders = User.most_orders

    @avg_order_value_week = Order.avg_value_since 7.days.ago
    @largest_order_value_week = Order.largest_value_since 7.days.ago

    @avg_order_value_month = Order.avg_value_since 30.days.ago
    @largest_order_value_month = Order.largest_value_since 30.days.ago

    @avg_order_value_total = Order.avg_value_total
    @largest_order_value_total = Order.largest_value_total

    @order_day_data = Order.past_week_data
    @order_week_data = Order.past_7_weeks_data
  end
end
