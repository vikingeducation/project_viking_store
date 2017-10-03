class Order < ApplicationRecord
  scope :placed, -> { where.not(checkout_date: nil) }
  scope :placed_since, ->(begin_date) {
    placed.where('checkout_date > ? AND checkout_date < ?', begin_date, Time.zone.now)
  }

  scope :product_orders, -> {
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
      .joins('JOIN products ON order_contents.product_id = products.id')
  }

  def self.placed_in_last(num_days)
    begin_date = eval("#{num_days}.days.ago")
    placed_since(begin_date)
  end

  def self.revenue
    product_orders
      .sum('products.price * order_contents.quantity')
      .to_f
  end

  def self.revenue_since(num_days)
    begin_date = eval("#{num_days}.days.ago")

    product_orders
      .where('checkout_date > ? AND checkout_date < ?',
             begin_date, Time.zone.now)
      .sum('products.price * order_contents.quantity')
      .to_f
  end

  def self.user_with_most_orders
    select("CONCAT(users.first_name, ' ', users.last_name) as name, COUNT(orders.*) as order_count")
      .joins('JOIN users ON orders.user_id = users.id')
      .group('users.first_name, users.last_name')
      .where('orders.checkout_date IS NOT NULL')
      .order('order_count DESC')
      .first
  end
end
