class Order < ApplicationRecord

  def self.count_by_days(num_days = nil)
    orders = select('COUNT(*) AS o_count')
    orders = orders.by_days(num_days) if num_days
    orders[0].o_count
  end

  def self.revenue(num_days = nil)
    revenue = select('SUM(price * quantity) AS total')
              .join_products
    revenue = revenue.by_days(num_days) if num_days
    ActionController::Base.helpers.number_to_currency(revenue[0].total)
  end

  def self.by_days(num_days)
    where("checkout_date >= ?", num_days.days.ago)
  end

  def self.join_products
    joins('JOIN order_contents ON (order_id = orders.id)')
    .joins('JOIN products ON (product_id = products.id)')
  end





end
