class DashboardController < ApplicationController
  def index
    @last_7_days = {"New Users" => User.user_count(7),
                      "Orders" => Order.order_count(7),
                      "New Products" => Product.product_count(7),
                      "Revenue" => OrderContent.revenue_by_time(7)}
    @last_30_days = {"New Users" => User.user_count(30),
                      "Orders" => Order.order_count(30),
                      "New Products" => Product.product_count(30),
                      "Revenue" => OrderContent.revenue_by_time(30)}
  end
end
