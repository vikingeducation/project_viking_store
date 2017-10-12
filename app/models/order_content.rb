class OrderContent < ApplicationRecord

  def revenue_stats
    revenue_hash = {}
      revenue_hash[:sevendays] = revenue_for(7.days.ago)
      revenue_hash[:thritydays] = revenue_for(30.days.ago)
      revenue_hash[:total] = revenue_for(FIRST_ORDER_DATE.created_at)
    revenue_hash
  end


  private


  def revenue_for(num_days_ago)
    OrderContent.join_ordercontents_and_products
                .where('order_contents.created_at >= ?', num_days_ago)
                .sum(REVENUE)
                .round
  end


end
