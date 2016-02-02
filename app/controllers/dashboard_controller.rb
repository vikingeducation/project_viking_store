class DashboardController < ApplicationController

  def index
    @data_hash = { 
      "New Users" => User.last_seven_days, 
      "Orders" =>  Order.last_seven_days, 
      "Products" => Product.last_seven_days, 
      "Revenue" => Order.revenue_last_seven_days }
  end

  def get
  end



end
