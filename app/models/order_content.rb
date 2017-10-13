class OrderContent < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first
  REVENUE = 'order_contents.quantity * products.price'
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago

  def revenue_statistics
    revenue_hash = {}
      revenue_hash[:sevendays] = revenue_for(SEVEN_DAYS)
      revenue_hash[:thirtydays] = revenue_for(THIRTY_DAYS)
      revenue_hash[:total] = revenue_for(FIRST_ORDER_DATE.created_at)
    revenue_hash
  end


  private


  def revenue_for(num_days_ago)
    OrderContent.joins('JOIN products ON products.id = order_contents.product_id')
                .where('order_contents.created_at >= ?', num_days_ago)
                .sum(REVENUE)
                .round
  end


end
