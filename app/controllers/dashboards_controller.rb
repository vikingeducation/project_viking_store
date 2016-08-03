class DashboardsController < ApplicationController
  def index
    @all_time_count = {"Users" => User.get_count,
                                    "Orders" => Order.get_count,
                                    "Products" => Product.get_count,
                                    "Revenue" => 0 }
    @seven_days_count =   {"Users" => User.get_count(7),
                                    "Orders" => Order.get_count(7),
                                    "Products" => Product.get_count(7),
                                    "Revenue" => 0 }
    @thirty_days_count =  {"Users" => User.get_count(30),
                                    "Orders" => Order.get_count(30),
                                    "Products" => Product.get_count(30),
                                    "Revenue" => 0 }                              

  end
end

OrderContent.find_by_sql("SELECT products.price FROM order_contents JOIN products ON order_contents.product_id = products.id JOIN orders ON orders.id = WHERE order_contents.id = 4")