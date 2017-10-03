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
  end
end
