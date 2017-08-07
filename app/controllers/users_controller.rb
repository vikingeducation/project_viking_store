class UsersController < ApplicationController

  def index
    @user_created_seven_days = User.user_created_seven_days
    @user_created_thirty_days = User.user_created_thirty_days
    @user_count_total = User.user_count
    @highest_single_order_value = 


  def highest_single_order_value
    User.find_by_sql("
      SELECT price * quantity AS order_value, users.first_name, orders.id, users.last_name FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      JOIN users on orders.user_id = users.id
      WHERE checkout_date IS NOT NULL
      ORDER BY order_value DESC
      LIMIT 1;
      ")

  end

  def highest_lifetime_value
    User.find_by_sql("
      SELECT SUM(price * quantity) AS order_value, users.first_name, orders.id, users.last_name FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      JOIN users on orders.user_id = users.id
      WHERE checkout_date IS NOT NULL
      GROUP BY orders.id, users.first_name, users.last_name
      ORDER BY order_value DESC
      LIMIT 1;
      ")
  end

   def highest_average_order
    User.find_by_sql("
      SELECT AVG(price * quantity) AS order_value, users.first_name, orders.id, users.last_name FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN products on products.id = order_contents.product_id
      JOIN users on orders.user_id = users.id
      WHERE checkout_date IS NOT NULL
      GROUP BY orders.id, users.first_name, users.last_name
      ORDER BY order_value DESC
      LIMIT 1;
      ")
  end

  def most_orders_placed
    User.find_by_sql("
      SELECT COUNT(orders.id) AS order_count, users.first_name, users.last_name FROM orders
      JOIN order_contents ON orders.id = order_contents.order_id
      JOIN users on orders.user_id = users.id
      WHERE checkout_date IS NOT NULL
      GROUP BY users.first_name, users.last_name
      ORDER BY order_count DESC
      LIMIT 1;
      ")
  end
end
