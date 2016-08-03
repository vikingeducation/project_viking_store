class DashboardsController < ApplicationController
  def index
    @all_time_count = {"Users" => User.get_count,
                                    "Orders" => Order.get_count,
                                    "Products" => Product.get_count,
                                    "Revenue" => 0 }


  end
end
