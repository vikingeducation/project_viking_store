class DashboardController < ApplicationController
  def home
    render locals: {
      total_users: User.count,
      total_orders: Order.count,
      total_products: Product.count,
      total_revenue: OrderContent.total_revenue
    }
  end
end
