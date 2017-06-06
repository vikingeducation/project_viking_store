class OrderContent < ApplicationRecord
  def self.revenue_by_days(days)
    if days == 0
      sql = "SELECT sum(order_contents.quantity * products.price)
            FROM order_contents JOIN products
            ON order_contents.product_id = products.id"
    else
      sql = "SELECT sum(order_contents.quantity * products.price)
            FROM order_contents JOIN products
            ON order_contents.product_id = products.id
            where order_contents.created_at >= current_date - interval '" + days.to_s + " days'"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end

  def self.average_order_value_by_days(days)
    if days == 0
      sql = "SELECT sum(t.order_total)/count(t.order_total)
            FROM (SELECT order_contents.order_id, sum(order_contents.quantity * products.price) as order_total
            FROM order_contents JOIN products
            ON order_contents.product_id = products.id
            GROUP BY order_contents.order_id) as t"
    else
      sql = "SELECT sum(t.order_total)/count(t.order_total)
              FROM (SELECT order_contents.order_id, sum(order_contents.quantity * products.price) as order_total
              FROM order_contents JOIN products
              ON order_contents.product_id = products.id
              WHERE order_contents.created_at >= current_date - interval '" + days.to_s + " days'
              GROUP BY order_contents.order_id) as t"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end

  def self.highest_order_value_by_days(days)
    if days == 0
      sql = "SELECT sum(order_contents.quantity * products.price) as total,     order_contents.order_id
              FROM order_contents JOIN products
              ON order_contents.product_id = products.id
              GROUP BY order_contents.order_id
              ORDER BY total DESC
              LIMIT 1"
    else
      sql = "SELECT sum(order_contents.quantity * products.price) as total,     order_contents.order_id
              FROM order_contents JOIN products
              ON order_contents.product_id = products.id
              WHERE order_contents.created_at >= current_date - interval '" + days.to_s + " days'
              GROUP BY order_contents.order_id
              ORDER BY total DESC
              LIMIT 1"
    end
    return ActiveRecord::Base.connection.exec_query(sql).rows[0][0]
  end
end
