class DashboardsController < ApplicationController

  def index

    user_num=User.user_created_days_ago(7)

    order_num=Order.order_created_days_ago(7)

    prod_num=Product.product_created_days_ago(7)

    tot_revenue = Order.total(7)
    @table_data={"New Users" => user_num, "Orders"=>order_num, "New Products" => prod_num, "Revenue" => revenue}

  end

end
