class DashboardController < ApplicationController

  def index
    @users= User.last_seven_days
    @orders = Order.last_seven_days
  end

  def get
  end



end
