class DashboardController < ApplicationController
  def index
  	@users_seven_days = User.where('created_at < ?', 7.days.ago).count
  	@orders_seven_days = Order.where('checkout_date > ?', 7.days.ago).count

  	@users_total = User.all.count
  	@orders_total = Order.all.count
  	@products_total = Product.all.count
  end
end


