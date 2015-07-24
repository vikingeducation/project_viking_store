class DashboardsController < ApplicationController

  def index


    @last7={ "New Users" => User.user_created_days_ago(7),
              "Orders"=>Order.order_created_days_ago(7),
              "New Products" => Product.product_created_days_ago(7),
              "Revenue" => Order.total(7)}


    @last30={ "New Users" => User.user_created_days_ago(30),
              "Orders"=>Order.order_created_days_ago(30),
              "New Products" => Product.product_created_days_ago(30),
              "Revenue" => Order.total(30)}

    @total={ "Users" => User.all,
              "Orders"=>Order.all,
              "Products" => Product.all,
              "Revenue" => Order.all}

  end

end
