class DashboardController < ApplicationController
  def index
    @highest_order_value = User.highest_order_value.first
  end
end
