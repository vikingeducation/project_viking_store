class OrderContent < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first

  belongs_to :order 

  def self.revenue_statistics
    revenue_hash = {}
      revenue_hash[:sevendays] = revenue_for(7.days.ago)
      revenue_hash[:thirtydays] = revenue_for(30.days.ago)
      revenue_hash[:total] = revenue_for(FIRST_ORDER_DATE.created_at)
    revenue_hash
  end


  private


  def self.revenue_for(num_days_ago)
    OrderContent.joins('JOIN products ON products.id = order_contents.product_id')
                .where('order_contents.created_at >= ?', num_days_ago)
                .sum('order_contents.quantity * products.price')
                .round
  end


end
