class DashboardController < ApplicationController
  def index
    @highest_order_value = User.highest_order_value.first
    @highest_lifetime_order_value = User.highest_lifetime_order_value.first
    @highest_average_order_value = User.highest_average_order_value.first

    @orders_by_date = Order.orders_by_day.map {|item| [item.date, item.sum, item.count]}

  end
end
