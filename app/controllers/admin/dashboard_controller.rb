class Admin::DashboardController < AdminController
  def index
    @highest_order_value = User.highest_order_value.first
    @highest_lifetime_order_value = User.highest_lifetime_order_value.first
    @highest_average_order_value = User.highest_average_order_value.first

    @orders_by_day = Order.orders_by_day.limit(7)
    @orders_by_week = Order.orders_by_week.limit(7)
  end
end
