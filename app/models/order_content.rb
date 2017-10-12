class OrderContent < ApplicationRecord

  def revenue_stats
    revenue_hash = {
      sevendays: revenue_for(7.days.ago)
      thritydays: revenue_for(30.days.ago)
      total: total_revenue
    }
  end


  private 


  def total_revenue
    OrderContent.joins('JOIN products ON products.id = order_contents.product_id')
                .sum("products.price * order_contents.quantity")
                .round
  end

  def revenue_for(num_days_ago)
    OrderContent.joins('JOIN products ON products.id = order_contents.product_id')
                .where('order_contents.created_at >= ?', num_days_ago)
                .sum("products.price * order_contents.quantity")
                .round
  end


end
