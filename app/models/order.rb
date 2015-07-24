class Order < ActiveRecord::Base

  def firsttable
    user_all=User.where("created_at > ?",Time.now - 7.day)
    user_num=user_all.count

    all_orders=Order.where("created_at > ?",Time.now - 7.day)
    order_num=all_orders.count

    prod_all=Product.where("created_at > ?",Time.now - 7.day)
    prod_num=prod_all.count

    revenue = Order.joins("JOIN order_contents ON orders.id = order_id").joins("JOIN products ON products.id = product_id").select("SUM(price * quantity) AS revenue").where("checkout_date > ?",Time.now - 7.day).first

    @table_data={"New Users" => user_num, "Orders"=>order_num, "New Products" => prod_num, "Revenue" => revenue}

  end
end
