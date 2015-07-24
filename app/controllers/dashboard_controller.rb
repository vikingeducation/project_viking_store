class DashboardController < ApplicationController

  def index
    @users = User.all
    @orders = Order.all
    @products = Product.all
    @revenue = Order.revenue.first.price

    @users_last_30 = User.count_last_30
    @users_last_7 = User.count_last_7

    @orders_count_last_30 = Order.count_last(30)
    @orders_count_last_7 = Order.count_last(7)

    @products_count_last_30 = Product.count_last(30)
    @products_count_last_7 = Product.count_last(7)
  end
end
