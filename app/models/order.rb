class Order < ActiveRecord::Base
  has_many :items, :class_name => 'OrderContent'
  belongs_to :user
  belongs_to :shipping, :class_name => 'Address'
  belongs_to :billing, :class_name => 'Address'
  belongs_to :credit_card

  # Returns the revenue for this order
  def revenue
    sql = 'SUM(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('order_contents.order_id = ?', id)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the order count of orders
  # with a checkout_date after the given date
  def self.count_since(date)
    Order.where('checkout_date > ?', date).count
  end

  # Returns the total revenue for all orders
  def self.revenue
    sql = 'SUM(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the total revenue for all orders
  # with a checkout_date after the given date
  def self.revenue_since(date)
    sql = 'SUM(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('orders.checkout_date > ?', date)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the average revenue for all orders
  def self.avg_revenue
    sql = 'AVG(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the average revenue for all orders
  # with a checkout_date after the given date
  def self.avg_revenue_since(date)
    sql = 'AVG(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('orders.checkout_date > ?', date)
      .limit(1)
      .to_a
      .first
    result ? result.amount.to_f : 0
  end

  # Returns the order with the highest revenue
  def self.with_max_revenue
    sql = 'orders.id AS order_id, SUM(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .group('orders.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
    Order.find(result.order_id) if result
  end

  # Returns the order with the highest revenue
  # with a checkout_date after the given date
  def self.with_max_revenue_since(date)
    sql = 'orders.id AS order_id, SUM(order_contents.quantity * products.price) AS amount'
    result = OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('orders.checkout_date > ?', date)
      .group('orders.id')
      .limit(1)
      .order('amount DESC')
      .to_a
      .first
    Order.find(result.order_id) if result
  end
end




