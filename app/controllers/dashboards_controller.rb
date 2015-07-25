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

    @orders_by_date=Order.orders_by_days
    @orders_by_week=Order.orders_by_week

    @orderlast7={ "Number of Orders" => Order.order_created_days_ago(7),
                  "Total Revenue" => Order.total(7).round,
                  "Average Order Value" => Order.avg_order_value(7),
                  "Largest Order Value" => Order.largest_order_value(7)}

    @orderlast30={"Number of Orders" => Order.order_created_days_ago(30),
                  "Total Revenue" => Order.total(30).round,
                  "Average Order Value" => Order.avg_order_value(30),
                  "Largest Order Value" => Order.largest_order_value(30)}

    @ordertotal={"Number of Orders" => Order.order_created_days_ago(10000),
                  "Total Revenue" => Order.total(10000).round,
                  "Average Order Value" => Order.avg_order_value(10000),
                  "Largest Order Value" => Order.largest_order_value(100000)}


  end

end
