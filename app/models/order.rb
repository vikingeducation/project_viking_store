class Order < ApplicationRecord
  def self.order_by_days(days)
    if days == 0
      sql = "select count(*)
      from orders"
    else
      sql = "select count(*)
      from orders
      where created_at >= current_date - interval '" + days.to_s + " days'"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end

  def self.highest_single_order(row, col)
    sql = "SELECT users.first_name, users.last_name, sum(order_contents.quantity * products.price) as total, orders.id
          FROM users join orders
          ON orders.user_id = users.id
          JOIN order_contents
          ON orders.id = order_contents.order_id
          JOIN products
          ON order_contents.product_id = products.id
          GROUP BY orders.id, users.last_name, users.first_name
          ORDER BY total DESC
          LIMIT 1"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]
  end

  def self.hightest_life_value(row, col)
    sql = "SELECT t.first_name, t.last_name, sum(t.order_total) as total
          FROM (SELECT users.first_name, users.last_name, sum(order_contents.quantity * products.price) as order_total
          FROM users join orders
          ON orders.user_id = users.id
          JOIN order_contents
          ON orders.id = order_contents.order_id
          JOIN products
          ON order_contents.product_id = products.id
          GROUP BY users.last_name, users.first_name) as t
          GROUP BY t.last_name, t. first_name
          ORDER BY total DESC
          LIMIT 1"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]

  end

  def self.highest_average_order(row,col)
    sql = "SELECT u.first_name, u.last_name, u.total/u.num_orders as avg
          FROM (SELECT t.first_name, t.last_name, t.num_orders, sum(t.order_total) as total
          FROM (SELECT users.first_name, users.last_name, sum(order_contents.quantity * products.price) as order_total, count(order_contents.id) as num_orders
          FROM users join orders
          ON orders.user_id = users.id
          JOIN order_contents
          ON orders.id = order_contents.order_id
          JOIN products
          ON order_contents.product_id = products.id
          GROUP BY users.last_name, users.first_name) as t
          GROUP BY t.last_name, t. first_name, t.num_orders) as u
          GROUP BY u.last_name, u.first_name, u.total, u.num_orders
          ORDER BY avg DESC
          LIMIT 1"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]
  end

  def self.most_orders_places(row, col)
    sql = "SELECT users.first_name, users.last_name, count(orders.id) as num_orders
            FROM users join orders
            ON orders.user_id = users.id
            GROUP BY users.last_name, users.first_name, orders.id
            ORDER BY num_orders DESC
            LIMIT 1"
    return ActiveRecord::Base.connection.exec_query(sql).rows[row][col]
  end

  def self.new_order_by_days(days)
    if days == 0
      sql  = "select count(*)
      from orders"
    else
      sql = "select count(*)
      from orders
      where created_at >= current_date - interval '" + days.to_s + " days'"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end

end
