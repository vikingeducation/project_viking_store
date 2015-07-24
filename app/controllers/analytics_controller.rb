class AnalyticsController < ApplicationController

  def dashboard
    @new_users_7 = User.user_count(7)
    @orders_7 = Order.order_count(7)
    @new_product_7 = Product.


    @new_users_30 = User.user_count(30)
  end
end
