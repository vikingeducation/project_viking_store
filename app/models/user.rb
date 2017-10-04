class User < ApplicationRecord
  scope :signed_up_since, ->(begin_date) {
    where('created_at > ? AND created_at < ?', begin_date, Time.zone.now)
  }

  def self.highest_value_by_revenue
    select("CONCAT(users.first_name, ' ', users.last_name) as name," \
           'SUM(products.price * order_contents.quantity) as revenue')
      .joins('JOIN orders ON orders.user_id = users.id')
      .joins('JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('JOIN products ON order_contents.product_id = products.id')
      .group('users.first_name, users.last_name')
      .order('revenue DESC')
      .first
  end

  def self.highest_average_order
    find_by_sql(
      "SELECT CONCAT(users.first_name, ' ', users.last_name) as name, MAX(order_totals.averages) as average
        FROM users
          JOIN orders
            ON orders.user_id = users.id
          JOIN (
                 SELECT
                   orders.id,
                   AVG(products.price * order_contents.quantity) as averages
                 FROM orders
                   JOIN order_contents ON orders.id = order_contents.order_id
                   JOIN products ON order_contents.product_id = products.id
                 GROUP BY orders.id
               ) as order_totals
            ON order_totals.id = orders.id
        GROUP BY users.first_name, users.last_name
        ORDER BY average DESC
        LIMIT 1"
    ).first
  end

  def self.with_largest_order
    find_by_sql(
      "SELECT CONCAT(users.first_name, ' ', users.last_name) as name, MAX(order_totals.totals) as order_amount
        FROM users
          JOIN orders
            ON orders.user_id = users.id
          JOIN (
                 SELECT
                   orders.id,
                   SUM(products.price * order_contents.quantity) as totals
                 FROM orders
                   JOIN order_contents ON orders.id = order_contents.order_id
                   JOIN products ON order_contents.product_id = products.id
                 GROUP BY orders.id
               ) as order_totals
            ON order_totals.id = orders.id
        GROUP BY users.first_name, users.last_name
        ORDER BY order_amount DESC
        LIMIT 1"
    ).first
  end

  def self.with_most_orders
    select("CONCAT(users.first_name, ' ', users.last_name) as name, COUNT(orders.*) as order_count")
      .joins('JOIN orders ON orders.user_id = users.id')
      .group('users.first_name, users.last_name')
      .where('orders.checkout_date IS NOT NULL')
      .order('order_count DESC')
      .first
  end
end
