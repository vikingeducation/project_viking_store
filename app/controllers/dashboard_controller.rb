class DashboardController < ApplicationController
  def index
  	@users_seven_days = User.where('created_at < ?', 7.days.ago).count
  	@orders_seven_days = Order.where('created_at < ?', 7.days.ago).count
  end
end
