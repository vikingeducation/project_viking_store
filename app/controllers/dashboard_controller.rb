class DashboardController < ApplicationController

  def index
    @seven_days = {
      "New Users" => User.last_seven_days,
      "Orders" =>  Order.last_seven_days,
      "Products" => Product.last_seven_days,
      "Revenue" => Order.revenue_last_seven_days }
    @thirty_days = {
      "New Users" => User.last_thirty_days,
      "Orders" =>  Order.last_thirty_days,
      "Products" => Product.last_thirty_days,
      "Revenue" => Order.revenue_last_thirty_days
    }
    @totals = {
      "Users" => User.total,
      "Orders" => Order.orders_total,
      "Products" => Product.total,
      "Revenue" => Order.revenue_total
    }
    top_three_states_query = User.top_three_states
  end

  def get
  end



end
