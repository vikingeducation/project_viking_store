class DashboardController < ApplicationController
  def home
    render locals: {
      total_users: User.count,
      total_orders: Order.count,
      total_products: Product.count,
      total_revenue: Order.total_revenue,

      new_users_within_30_days: User.new_users(30),
      orders_placed_within_30_days: Order.orders_placed(30),
      new_products_within_30_days: Product.new_products(30),
      revenue_within_30_days: Order.revenue_within(30),

      new_users_within_7_days: User.new_users(7),
      orders_placed_within_7_days: Order.orders_placed(7),
      new_products_within_7_days: Product.new_products(7),
      revenue_within_7_days: Order.revenue_within(7),

      top_3_states_by_billing_address: State.top_3_states_by_billing_address,
      top_3_cities_by_billing_address: City.top_3_cities_by_billing_address,
      highest_single_order_value: Order.highest_single_order_value,
      highest_lifetime_value: Order.highest_lifetime_value,
      highest_average_order_value: Order.highest_average_order_value,
      user_with_most_orders_placed: Order.user_with_most_orders_placed,

      total_average_order_value: Order.total_average_order_value
    }
  end
end
