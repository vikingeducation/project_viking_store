class Order < ApplicationRecord

  has_many :order_contents, :foreign_key => :order_id, :dependent => :nullify
  has_many :products, :through => :order_contents, :source => :product
  belongs_to :user

  def self.by_day
    Order.select("orders.created_at, COUNT(orders.created_at) AS quantity, SUM(order_contents.quantity * products.price) AS order_value")
          .join_with_products
          .where("checkout_date IS NOT NULL")
          .group("orders.created_at, orders.id")
          .order("orders.created_at")
          .limit(7)
  end

  def self.by_week
    Order.find_by_sql("
      SELECT DATE(weeks) AS week,
      COUNT(orders.created_at) AS quantity,
      COALESCE(SUM(order_contents.quantity * products.price), 0) AS order_value
        FROM GENERATE_SERIES((
              SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) weeks
                LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks
        LEFT JOIN order_contents ON orders.id = order_contents.order_id
        LEFT JOIN products ON products.id = order_contents.product_id
        GROUP BY weeks
        ORDER BY weeks DESC
        LIMIT 10
      ")
  end

  def self.total(num_days=nil)
    if num_days
      Order.where("created_at > ?", num_days.days.ago).count
    else
      Order.all.count
    end
  end

  def self.total_revenue
    Order.select('SUM(price * quantity) AS sum')
                   .join_with_products
                   .where("checkout_date IS NOT NULL")

  end

  def self.with_order_values
    Order.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
          .join_with_products
          .where("checkout_date IS NOT NULL")
          .group("orders.id")
          .order("order_value DESC")
  end

  def self.largest_order_value(num_days=nil)
    if num_days
      Order.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .where("checkout_date <= ?", num_days.days.ago)
            .group("orders.id")
            .order("order_value DESC")
            .limit(1)
    else
      Order.with_order_values.limit(1)
    end
  end

  def self.average_order_value(num_days=nil)
    if num_days
      Order.select("AVG(order_contents.quantity * products.price) AS avg_order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .where("checkout_date <= ?", num_days.days.ago)
            .group("orders.id")
            .order("avg_order_value DESC")
            .limit(1)
    else
      Order.select("AVG(order_contents.quantity * products.price) AS avg_order_value")
            .join_with_products
            .where("checkout_date IS NOT NULL")
            .group("orders.id")
            .order("avg_order_value DESC")
            .limit(1)
    end
  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end

end