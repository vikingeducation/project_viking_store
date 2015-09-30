class Order < ActiveRecord::Base
  has_many :items, :class_name => 'OrderContent'
  has_many :products, :through => :items
  belongs_to :user
  belongs_to :shipping, :class_name => 'Address'
  belongs_to :billing, :class_name => 'Address'
  belongs_to :credit_card
  has_many :categories, :through => :products

  COALESCE_QUANTITY_PRICE = 'COALESCE(SUM(order_contents.quantity * products.price), 0) AS amount'
  SUM_QUANTITY_PRICE = 'SUM(order_contents.quantity * products.price) AS amount'
  GENERATE_DAYS = "GENERATE_SERIES((SELECT DATE(MIN(checkout_date)) FROM orders), CURRENT_DATE, '1 DAY'::INTERVAL) day"
  GENERATE_WEEKS = "GENERATE_SERIES((SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders), CURRENT_DATE, '1 WEEK'::INTERVAL) weeks"

  # --------------------------------
  # Public Instance Methods
  # --------------------------------

  # Returns the revenue for this order
  def revenue
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .where('order_contents.order_id = ?', id)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # --------------------------------
  # Public Class Methods
  # --------------------------------

  # Returns all orders without a
  # checkout date
  def self.carts
    Order.where('checkout_date IS NULL')
  end

  # Returns the order count of orders
  # with a checkout_date after the given date
  def self.count_since(date)
    Order.where('checkout_date >= ?', date.to_date).count
  end

  # Returns the total revenue for all orders
  def self.revenue
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the total revenue for all orders
  # with a checkout_date after the given date
  def self.revenue_since(date)
    result = Order.join_order_contents_products(SUM_QUANTITY_PRICE)
      .where('orders.checkout_date >= ?', date.to_date)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the average revenue for all orders
  def self.avg_revenue
    count = Order.count
    count == 0 ? 0 : Order.revenue / count
  end

  # Returns the average revenue for all orders
  # with a checkout_date after the given date
  def self.avg_revenue_since(date)
    count = Order.count_since(date)
    count == 0 ? 0 : Order.revenue_since(date) / count
  end

  # Returns the order with the highest revenue
  def self.with_max_revenue
    result = Order.prepare_max_revenue
      .to_a
      .first
    Order.result_order_id_or_new(result)
  end

  # Returns the order with the highest revenue
  # with a checkout_date after the given date
  def self.with_max_revenue_since(date)
    result = Order.prepare_max_revenue
      .where('orders.checkout_date >= ?', date.to_date)
      .to_a
      .first
    Order.result_order_id_or_new(result)
  end

  # Returns the revenue for every day since the
  # first checkout date
  def self.revenue_by_day
    Order.join_days_revenue
      .to_a
  end

  # Returns the revenue for a specific day
  def self.revenue_for_day(date)
    Order.join_days_revenue
      .where('day = ?', date.to_date)
      .to_a
  end

  # Returns the count for every day since the
  # first checkout date
  def self.count_by_day
    Order.join_days_count
      .to_a
  end

  # Returns the count for a specific day
  def self.count_for_day(date)
    Order.join_days_count
      .where('day = ?', date.to_date)
      .to_a
  end

  # Returns the revenue for every week since the
  # week of the first checkout date
  def self.revenue_by_week
    Order.join_weeks_revenue
      .to_a
  end

  # Returns the revenue for a specific week
  def self.revenue_for_week(date)
    Order.join_weeks_revenue
      .where('weeks = ?', date.to_date.beginning_of_week)
      .to_a
  end

  # Returns the count for every week since the
  # week of the first checkout date
  def self.count_by_week
    Order.join_weeks_count
      .to_a
  end

  # Returns the count for a specific week
  def self.count_for_week(date)
    Order.join_weeks_count
      .where('weeks = ?', date.to_date.beginning_of_week)
      .to_a
  end


  private

  # --------------------------------
  # Private Class Methods
  # --------------------------------

  # Wraps reusable find order by id or instantiate new order
  def self.result_order_id_or_new(result)
    order = Order.find(result.order_id) if result
    order || Order.new
  end

  # Wraps reusable join on orders, order_contents and products
  def self.join_order_contents_products(sql='*')
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
  end

  # Wraps reusable join on day series and revenue by day
  def self.join_days_revenue
    select_statement = [
      'DATE(day)',
      COALESCE_QUANTITY_PRICE
    ].join(',')

    from_statement = GENERATE_DAYS

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins('LEFT JOIN orders ON DATE(orders.checkout_date) = day')
      .joins('LEFT JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('LEFT JOIN products ON products.id = order_contents.product_id')
      .group('day')
      .order('day DESC')
  end

  # Wraps reusable join on day series and count by day
  def self.join_days_count
    select_statement = [
      'DATE(day)',
      'COUNT(orders.*) AS num_orders'
    ].join(',')

    from_statement = GENERATE_DAYS

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins('LEFT JOIN orders ON DATE(orders.checkout_date) = day')
      .group('day')
      .order('day DESC')
  end

  # Wraps reusable join on week series and revenue by week
  def self.join_weeks_revenue
    select_statement = [
      'DATE(weeks) AS week',
      COALESCE_QUANTITY_PRICE
    ]

    from_statement = GENERATE_WEEKS

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins("LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks")
      .joins('LEFT JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('LEFT JOIN products ON products.id = order_contents.product_id')
      .group('weeks')
      .order('weeks DESC')
  end

  # Wraps reusable join on weeks series and count by week
  def self.join_weeks_count
    select_statement = [
      'DATE(weeks) AS week',
      'COALESCE(COUNT(orders.*), 0) AS num_orders'
    ].join(',')

    from_statement = GENERATE_WEEKS

    OrderContent.select(select_statement)
      .from(from_statement)
      .joins("LEFT JOIN orders ON DATE(DATE_TRUNC('WEEK', orders.checkout_date)) = weeks")
      .group('weeks')
      .order('weeks DESC')
  end

  # Wraps reusable query to find max revenue
  def self.prepare_max_revenue
    sql = [
      'orders.id AS order_id',
      SUM_QUANTITY_PRICE
    ].join(',')
    Order.join_order_contents_products(sql)
      .group('orders.id')
      .limit(1)
      .order('amount DESC')
  end
end




