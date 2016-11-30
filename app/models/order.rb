class Order < ApplicationRecord

  def self.count_by_days(num_days)
    orders = select('COUNT(*) AS o_count')
    orders = orders.where("checkout_date >= ?", num_days.days.ago) if num_days
    orders[0].o_count
  end

  def self.revenue_by_days(num_days)
    revenue = Order.select('SUM(price * quantity) AS total')
                   .joins('JOIN order_contents ON (order_id = orders.id)')
                   .joins('JOIN products ON (product_id = products.id)')
    revenue = revenue.where("checkout_date >= ?", num_days.days.ago) if num_days
    ActionController::Base.helpers.number_to_currency(revenue[0].total)
  end
end
