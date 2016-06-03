class Order < ActiveRecord::Base
  has_many :order_contents
  has_many :products, :through => :order_contents
  belongs_to :user
  belongs_to :credit_card

  belongs_to :address, :foreign_key => :shipping_id

  has_many :categories, :through => :products

  # validates :shipping_id, :billing_id, :presence => true

  before_create do |order|
    user = order.user
    unless user.orders.where(checkout_date: nil).count == 0
      false
    end
  end


  def self.total
    Order.where("checkout_date IS NOT NULL").count
  end

  def cart?
    self.checkout_date.nil?
  end

  def self.revenue
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
    .joins("JOIN products p ON product_id = p.id")
    .sum("oc.quantity * p.price")
  end

  def self.new_orders(t)
    Order.where("checkout_date IS NOT NULL").where("checkout_date > ?", Time.now - t*24*60*60).count
  end

  def self.revenue_days(t)
    Order.joins("AS o JOIN order_contents oc ON o.id = oc.order_id")
    .joins("JOIN products p ON product_id = p.id")
    .where("checkout_date > ?", Time.now - t*24*60*60)
    .sum("oc.quantity * p.price")
  end

  def self.avg_order_value
    Order.find_by_sql("SELECT AVG(sum_order) AS avg_order FROM
                         (SELECT SUM(p.price * oc.quantity) AS sum_order
                          FROM orders
                          JOIN order_contents oc ON orders.id = oc.order_id
                          JOIN products p ON oc.product_id = p.id
                          WHERE orders.checkout_date IS NOT NULL
                          GROUP BY orders.id) s ")
  end


  def self.largest_order_value
    Order.select("SUM(p.price * oc.quantity) AS total")
         .joins("JOIN order_contents oc ON orders.id = oc.order_id")
         .joins("JOIN products p ON oc.product_id = p.id")
         .where("orders.checkout_date IS NOT NULL")
         .group("orders.id")
         .order("total DESC")
         .limit(1)
  end


  def self.avg_order_value_days(t)
    Order.find_by_sql("SELECT AVG(sum_order) AS avg_order FROM
                         (SELECT SUM(p.price * oc.quantity) AS sum_order
                          FROM orders
                          JOIN order_contents oc ON orders.id = oc.order_id
                          JOIN products p ON oc.product_id = p.id
                          WHERE orders.checkout_date IS NOT NULL
                          AND orders.checkout_date BETWEEN NOW() - INTERVAL '#{t} days' AND NOW()
                          GROUP BY orders.id) s ")
  end

  def self.largest_order_value_days(t)
    Order.select("SUM(p.price * oc.quantity) AS total")
         .joins("JOIN order_contents oc ON orders.id = oc.order_id")
         .joins("JOIN products p ON oc.product_id = p.id")
         .where("orders.checkout_date IS NOT NULL")
         .where("orders.checkout_date BETWEEN NOW() - INTERVAL '#{t} days' AND NOW()")
         .group("orders.id")
         .order("total DESC")
         .limit(1)
  end

  def self.orders_by_day
    Order.find_by_sql("SELECT SUM(p.price * oc.quantity) AS value, DATE(days) AS day,
                       COUNT(o.*) AS quantity
                       FROM GENERATE_SERIES(CURRENT_DATE - INTERVAL '7 DAYS', CURRENT_DATE, INTERVAL '1 DAY') days
                       LEFT JOIN orders o ON DATE(o.checkout_date) = days
                       LEFT JOIN order_contents oc ON o.id = oc.order_id
                       LEFT JOIN products p ON p.id = oc.product_id
                       GROUP BY days
                       ORDER BY days DESC
                       LIMIT 7 ")
  end


  def self.orders_by_week
    Order.find_by_sql("SELECT COALESCE(SUM(p.price * oc.quantity)) AS value, DATE(weeks) AS week,
                       COALESCE(COUNT(o.*)) AS quantity
                       FROM GENERATE_SERIES(DATE(DATE_TRUNC('WEEK', CURRENT_DATE - INTERVAL '7 WEEKS')), CURRENT_DATE, INTERVAL '1 WEEK') weeks
                       LEFT JOIN orders o ON DATE(DATE_TRUNC('WEEK', o.checkout_date)) = weeks
                       LEFT JOIN order_contents oc ON o.id = oc.order_id
                       LEFT JOIN products p ON p.id = oc.product_id
                       GROUP BY weeks
                       ORDER BY weeks DESC
                       LIMIT 7 ")
  end


  def is_placed
    self.checkout_date ? true : false
  end

end









