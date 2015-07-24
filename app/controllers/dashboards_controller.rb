class DashboardsController < ApplicationController

  def index


    @last7={ "New Users" => User.user_created_days_ago(7),
              "Orders"=> Order.order_created_days_ago(7),
              "New Products" => Product.product_created_days_ago(7),
              "Revenue" => Order.total(7).round}


    @last30={ "New Users" => User.user_created_days_ago(30),
              "Orders"=> Order.order_created_days_ago(30),
              "New Products" => Product.product_created_days_ago(30),
              "Revenue" => Order.total(30).round}

    @total={ "Users" => User.all.count,
              "Orders"=> Order.all.count,
              "Products" => Product.all.count,
              "Revenue" => Order.total(100000).round}

    @user_3_states=User.top_3_states

    @user_3_cities=User.top_3_cities

    @top_users=User.top_user_with


  end

end
