class DashboardsController < ApplicationController

  def index
    
    user_all=User.where("created_at > ?",Time.now - 7.day)
     user_num=user_all.count

    all_orders=Order.where("created_at > ?",Time.now - 7.day)
    order_num=all_orders.count

    prod_all=Product.where("created_at > ?",Time.now - 7.day)
    prod_num=prod_all.count

    revenue = 0
    days=7.days.ago
    all_orders.each do |order|
      revenue+=Order.find_by_sql("SELECT sum(price * quantity) AS sum FROM orders JOIN order_contents ON (orders.id = order_id) JOIN products ON (products.id = product_id) WHERE orders.checkout_date < #{days}") 
    end
    @table_data={"New Users" => user_num, "Orders"=>order_num, "New Products" => prod_num, "Revenue" => revenue}
    # Order.join(order_contents).join(products).where("checkout_date < ?", )
  end

end
