class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_contents
  has_many :products, through: :order_contents
  has_many :categories, through: :products

  def self.new_orders(days_since)
    self.where("checkout_date > '#{DateTime.now - days_since}'").count
  end

  def self.total
    self.count
  end

  def self.revenue(days_since)
    self.join_with_products
        .where("checkout_date > '#{DateTime.now - days_since}' AND orders.checkout_date IS NOT null")
        .sum("price * quantity")
  end

  def self.total_revenue
    self.join_with_products
        .where("orders.checkout_date IS NOT null")
        .sum("order_contents.quantity * products.price")
  end

  def self.highest_single_order_user
    self.select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("orders.id, users.first_name, users.last_name")
        .order('order_value desc')
        .limit(1)
  end

  def self.highest_lifetime_order_user
    self.select("users.first_name, users.last_name, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('order_value desc')
        .limit(1)
  end

  def self.highest_avg_order_user
    self.select("users.first_name, users.last_name, COUNT(distinct orders.id) AS order_count,
                 SUM(order_contents.quantity * products.price) AS order_value,
                 sum(price * quantity) / count(distinct orders.id) AS avg_price")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('avg_price desc')
        .limit(1)
  end


  def self.most_orders_user
    self.select("users.first_name, users.last_name, COUNT(users.id) AS order_count")
        .join_with_products
        .join_with_users
        .where("orders.checkout_date IS NOT null")
        .group("users.id, users.first_name, users.last_name")
        .order('order_count desc')
        .limit(1)
  end


  def self.orders_with_values
    self.select("orders.*, SUM(order_contents.quantity * products.price) AS order_value")
        .join_with_products
        .group("orders.id")
        .order('order_value desc')
  end

  def self.average_ar
    self.orders_with_values.average("order_value").to_sql
  end

  def self.average
    self.find_by_sql("
      SELECT AVG(order_value)
      FROM(
        SELECT orders.*, SUM(order_contents.quantity *  products.price) AS order_value
        FROM orders JOIN order_contents ON orders.id = order_contents.order_id
        JOIN products ON products.id = order_contents.product_id
        WHERE orders.checkout_date IS NOT null
        GROUP BY orders.id
        ) as table1
    ")
  end

  def self.total_number
    self.where("orders.checkout_date IS NOT null").count
  end

  def self.avg_value
    total_revenue/total_number
  end

  def self.largest_value
    self.highest_single_order_user[0].order_value
  end

  def self.highest_order_since(days_since)
    self.orders_with_values
        .where("checkout_date > '#{DateTime.now - days_since}' AND orders.checkout_date IS NOT null")
        .limit(1)
  end


  def self.by_date(num_days)
    self.find_by_sql("
      SELECT DATE(days) AS day, COUNT(DISTINCT orders.*) AS num_orders,
      COALESCE(SUM(order_contents.quantity * products.price), 0) AS amount
      FROM GENERATE_SERIES(
        (SELECT DATE(MIN(checkout_date))
        FROM orders)
      , CURRENT_DATE, '1 DAY'::INTERVAL) days
      LEFT JOIN orders ON DATE(orders.checkout_date) = days
      LEFT JOIN order_contents ON orders.id = order_contents.order_id
      LEFT JOIN products ON products.id = order_contents.product_id
      GROUP BY days
      ORDER BY days DESC
      LIMIT #{num_days}
    ")
  end

  def self.by_week(num_weeks)
    self.find_by_sql("
      SELECT DATE(weeks) AS week, COUNT(DISTINCT orders.*) AS num_orders,
      COALESCE(SUM(order_contents.quantity * products.price), 0) AS amount
      FROM GENERATE_SERIES(
        (SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date)))
         FROM orders)
      , CURRENT_DATE, '1 WEEK'::INTERVAL) weeks
      LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks
      LEFT JOIN order_contents ON orders.id = order_contents.order_id
      LEFT JOIN products ON products.id = order_contents.product_id
      GROUP BY weeks
      ORDER BY weeks DESC
      LIMIT #{num_weeks}
    ")
  end

  def self.join_with_users
    joins("JOIN users ON orders.user_id = users.id")
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
