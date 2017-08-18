class DashboardController < ApplicationController
  def home
    render locals: {
      total_users: User.count,
      total_orders: Order.count,
      total_products: Product.count,
      total_revenue: Order.total_revenue,

      new_users_within_30_days: User.new_users(30),
      orders_within_30_days: Order.orders_within(30),
      new_products_within_30_days: Product.new_products(30),
      revenue_within_30_days: Order.revenue_within(30),

      new_users_within_7_days: User.new_users(7),
      orders_within_7_days: Order.orders_within(7),
      new_products_within_7_days: Product.new_products(7),
      revenue_within_7_days: Order.revenue_within(7),

      top_3_states_by_billing_address: State.top_3_states_by_billing_address,
      top_3_cities_by_billing_address: City.top_3_cities_by_billing_address,
      user_with_highest_single_order_value: Order.user_with_highest_single_order_value,
      user_with_highest_lifetime_value: Order.user_with_highest_lifetime_value,
      user_with_highest_average_order_value: Order.user_with_highest_average_order_value,
      user_with_most_orders_placed: Order.user_with_most_orders_placed,

      average_order_value_across_all_time: Order.average_order_value_across_all_time,
      largest_order_value_across_all_time: Order.largest_order_value_across_all_time,

      average_order_value_within_30_days: Order.average_order_value_within(30),
      largest_order_value_within_30_days: Order.largest_order_value_within(30),

      average_order_value_within_7_days: Order.average_order_value_within(7),
      largest_order_value_within_7_days: Order.largest_order_value_within(7),

      orders_by_day: Order.format_orders(Order.orders_by_day),
      orders_by_week: Order.format_orders(Order.orders_by_week)
    }
  end
end
