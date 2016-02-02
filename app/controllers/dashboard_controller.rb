class DashboardController < ApplicationController
  def index
    @highest_order_value = User.highest_order_value.first
    @highest_lifetime_order_value = User.highest_lifetime_order_value.first
    @highest_average_order_value = User.highest_average_order_value.first
  end
end
