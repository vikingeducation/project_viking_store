class Order < ActiveRecord::Base

  belongs_to :users
  has_many :products, through: :order_products

  def self.count_recent(n)
    Order.all.where("checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end


  def self.revenue_recent(n)
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .sum("oc.quantity * p.price")
  end


  def self.orders_total
    Order.all.where("orders.checkout_date IS NOT NULL").count
  end

  def self.revenue_total
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date IS NOT NULL")
         .sum("oc.quantity * p.price")
  end


  def self.average_order(n)
    Order.joins("AS o JOIN users u on u.id = o.user_id")
         .joins("JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .average("(oc.quantity * p.price)")
  end


  def self.largest_order(n)
    Order.select("SUM(oc.quantity * p.price) AS largest_order")
         .joins("AS o JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
         .group("o.id")
         .order("largest_order DESC")
         .limit(1)
  end

  def self.average_total
    Order.joins("AS o JOIN users u on u.id = o.user_id")
         .joins("JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date IS NOT NULL")
         .average("(oc.quantity * p.price)")
  end

  def self.largest_total
    Order.joins("AS o JOIN order_contents oc ON oc.order_id = o.id")
         .joins("JOIN products p ON p.id = oc.product_id")
         .where("o.checkout_date IS NOT NULL")
         .maximum("oc.quantity * p.price")
  end



  def self.daily_timeseries_orders
    Order.find_by_sql("
      SELECT
        DATE(days) AS day,
        SUM(oc.quantity * p.price) AS daily_sum,
        COUNT(o.*) AS num_orders
        FROM GENERATE_SERIES((
          SELECT DATE(MIN(checkout_date)) FROM orders
        ), CURRENT_DATE, '1 DAY'::INTERVAL) days
        LEFT JOIN orders o ON DATE(o.checkout_date) = days
        LEFT JOIN order_contents oc ON oc.order_id = o.id
        LEFT JOIN products p ON p.id = oc.product_id
        GROUP BY days
        ORDER BY days DESC LIMIT 7;")
  end


  def self.weekly_timeseries_orders
    Order.find_by_sql("
      SELECT
      DATE(weeks) AS week,
      SUM(oc.quantity * p.price) AS weekly_sum,
      COUNT(o.*) AS num_orders
      FROM GENERATE_SERIES((
        SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders)
      , CURRENT_DATE, '1 WEEK'::INTERVAL) weeks
      LEFT JOIN orders o ON DATE(DATE_TRUNC('WEEK', o.checkout_date)) = weeks
      LEFT JOIN order_contents oc ON oc.order_id = o.id
      LEFT JOIN products p ON p.id = oc.product_id
      GROUP BY weeks
      ORDER BY weeks DESC LIMIT 7;")
  end



end
