class DashboardController < ApplicationController
  def home
    render locals: {
      total_users: User.count,
      total_orders: Order.count,
      total_products: Product.count,
      total_revenue: OrderContent.total_revenue,

      new_users_within_30_days: User.new_users(30),
      orders_placed_within_30_days: Order.orders_placed(30),
      new_products_within_30_days: Product.new_products(30),
      revenue_within_30_days: OrderContent.revenue(30),

      new_users_within_7_days: User.new_users(7),
      orders_placed_within_7_days: Order.orders_placed(7),
      new_products_within_7_days: Product.new_products(7),
      revenue_within_7_days: OrderContent.revenue(7),
    }
  end
end
