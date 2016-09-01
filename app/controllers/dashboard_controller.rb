class DashboardController < ApplicationController

  def index
    @user_count = User.all.count
    @order_count = Order.all.count
    @product_count = Product.all.count
    @total_revenue = Order.total_revenue
  end
end
