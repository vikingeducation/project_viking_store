class Order < ApplicationRecord
  scope :placed, -> { where.not(checkout_date: nil) }
  scope :placed_since, ->(begin_date) {
    placed.where('checkout_date > ? AND checkout_date < ?', begin_date, Time.zone.now)
  }

  scope :product_orders, -> {
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('JOIN products ON order_contents.product_id = products.id')
  }

  def self.average_total
    first_order = product_orders.placed.order(:checkout_date).first
    average_total_since(first_order.checkout_date)
  end

  def self.average_total_since(begin_date)
    find_by_sql(
      "SELECT AVG(order_totals.totals) as average
        FROM orders
          JOIN (
                 SELECT
                   orders.id,
                   orders.checkout_date,
                   SUM(products.price * order_contents.quantity) as totals
                 FROM orders
                   JOIN order_contents ON orders.id = order_contents.order_id
                   JOIN products ON order_contents.product_id = products.id
                   WHERE orders.checkout_date BETWEEN date '#{begin_date.to_date}' AND current_timestamp
                 GROUP BY orders.id
               ) as order_totals
            ON order_totals.id = orders.id"
    )
      .first
      .average
      .round(2)
  end

  def self.largest_total
    first_order = product_orders.placed.order(:checkout_date).first
    largest_total_since(first_order.checkout_date)
  end

  def self.largest_total_since(begin_date)
    find_by_sql(
      "SELECT MAX(order_totals.totals) as largest_total
        FROM orders
          JOIN (
                 SELECT
                   orders.id,
                   orders.checkout_date,
                   SUM(products.price * order_contents.quantity) as totals
                 FROM orders
                   JOIN order_contents ON orders.id = order_contents.order_id
                   JOIN products ON order_contents.product_id = products.id
                   WHERE orders.checkout_date BETWEEN date '#{begin_date.to_date}' AND current_timestamp
                 GROUP BY orders.id
               ) as order_totals
            ON order_totals.id = orders.id"
    )
      .first
      .largest_total
  end

  def self.by_day
    begin_date = 1.week.ago.to_date
    find_by_sql(
      "SELECT
        orders_and_dates.date,
        COUNT(orders_and_dates.*) as quantity,
        SUM(total) as value
      FROM (SELECT date(orders.checkout_date), order_totals.totals as total
            FROM orders
              JOIN (
                     SELECT
                       orders.id,
                       orders.checkout_date,
                       SUM(products.price * order_contents.quantity) as totals
                     FROM orders
                       JOIN order_contents ON orders.id = order_contents.order_id
                       JOIN products ON order_contents.product_id = products.id
                     WHERE orders.checkout_date BETWEEN date '#{begin_date}' AND current_timestamp
                     GROUP BY orders.checkout_date, orders.id
                   ) as order_totals
                ON order_totals.id = orders.id
            ) orders_and_dates
      GROUP BY orders_and_dates.date
      ORDER BY orders_and_dates.date DESC"
    )
  end

  def self.revenue
    product_orders
      .sum('products.price * order_contents.quantity')
  end

  def self.revenue_since(begin_date)
    product_orders
      .where('checkout_date > ? AND checkout_date < ?',
             begin_date, Time.zone.now)
      .sum('products.price * order_contents.quantity')
  end
end
