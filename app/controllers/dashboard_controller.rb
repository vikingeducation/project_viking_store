class DashboardController < ApplicationController
  def show
    @last_seven_days = {
      users: User.last_seven_days,
      orders: Order.last_seven_days,
      products: Product.last_seven_days,
      revenue: Product.revenue_last_seven_days
    }
    @last_thirty_days = {
      users: User.last_thirty_days,
      orders: Order.last_thirty_days,
      products: Product.last_thirty_days,
      revenue: Product.revenue_last_thirty_days 
    }
  end
end
