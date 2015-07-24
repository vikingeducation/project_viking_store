class DashboardController < ApplicationController

  def index
    @users = User.all
    @orders = Order.all
    @products = Product.all
    @revenue = Order.revenue.first.price
  end
end
