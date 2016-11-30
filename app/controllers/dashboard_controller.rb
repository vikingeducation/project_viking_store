class DashboardController < ApplicationController
  include DashboardHelper
  def index
    @users_seven_days = total_users(7)
    @orders_seven_days = total_orders(7)
    @products_seven_days = total_new_products(7)
    @revenue_seven_days = total_revenue(7)


  end


end
