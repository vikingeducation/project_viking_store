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
  end
end
