class User < ApplicationRecord
  scope :signed_up_since, ->(begin_date) {
    where('created_at > ? AND created_at < ?', begin_date, Time.zone.now)
  }

  def self.signed_up_in_last(num_days)
    begin_date = eval("#{num_days}.days.ago")
    signed_up_since(begin_date)
  end

  def self.largest_order_to_date
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
end
