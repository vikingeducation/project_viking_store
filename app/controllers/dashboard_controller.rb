class DashboardController < ApplicationController
  def show
    @last_seven_days = {
      users: User.last_seven_days,
      orders: Order.last_seven_days,
      products: Product.last_seven_days,
      revenue: Product.revenue_last_seven_days
    }
  end
end
