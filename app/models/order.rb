class Order < ActiveRecord::Base
  has_many :items, :class_name => 'OrderContent'
  belongs_to :user
  belongs_to :shipping, :class_name => 'Address'
  belongs_to :billing, :class_name => 'Address'
  belongs_to :credit_card

  # Returns the revenue for this order
  def revenue
    sql = 'SUM(order_contents.quantity * products.price) AS revenue'
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('order_contents.order_id = ?', id)
      .limit(1)
      .to_a
      .first
      .revenue
      .to_f
  end

  # Returns the order count of orders
  # with a checkout_date after the given date
  def self.count_since(date)
    Order.where('checkout_date > ?', date).count
  end

  # Returns the total revenue for all orders
  def self.revenue
    sql = 'SUM(order_contents.quantity * products.price) AS revenue'
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .limit(1)
      .to_a
      .first
      .revenue
      .to_f
  end

  # Returns the total revenue for all orders
  # with a checkout_date after the given date
  def self.revenue_since(date)
    sql = 'SUM(order_contents.quantity * products.price) AS revenue'
    OrderContent.select(sql)
      .joins(:product)
      .joins(:order)
      .where('orders.checkout_date > ?', date)
      .limit(1)
      .to_a
      .first
      .revenue
      .to_f
  end
end
