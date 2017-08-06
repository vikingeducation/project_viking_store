class User < ApplicationRecord

  def user_created_seven_days
    User.where('created_at > ?',(Time.now - 7.days)).count 
  end

  def user_created_thirty_days
    User.where('created_at > ?',(Time.now - 30.days)).count 
  end

  def user_count
    User.count 
  end

  def highest_single_order_value
    User.find_by_sql("
      SELECT SUM(price * quantity) AS order_value, users.first_name, orders.id FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      JOIN users on orders.user_id = users.id
      WHERE checkout_date IS NOT NULL
      GROUP BY orders.id, users.first_name
      ORDER BY order_value DESC
      LIMIT 1;
      ")

  end

end
