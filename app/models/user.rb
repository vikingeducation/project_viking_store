class User < ApplicationRecord

  def self.user_count
    User.count 
  end

  def self.user_created(days)
    User.where('created_at > ?',(Time.now - days.days)).count 
  end


  def self.highest_single_order_value
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



  def self.highest_lifetime_value
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

   def self.highest_average_order
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

  def self.most_orders_placed
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
  
  def self.admin_info
    User.find_by_sql("
        SELECT users.id, first_name, users.created_at AS joined, cities.name AS city, states.name AS state, SUM(orders.id) AS orders, MAX(orders.created_at) AS last_order_date FROM users
        JOIN addresses on addresses.user_id = users.id
        JOIN cities on cities.id = addresses.city_id
        JOIN states on states.id = addresses.state_id
        JOIN orders on orders.user_id = users.id
        WHERE checkout_date IS NOT NULL
          GROUP BY users.id, first_name, joined, city, state
          ORDER BY users.id;
        ")
  end
end
