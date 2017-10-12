class Product < ApplicationRecord

  def product_stats
    product_stats_hash = {}
      product_stats_hash[:new_sevendays] = overall_count(Product, 7.days.ago)
      product_stats_hash[:new_thirtydays] = overall_count(Product, 30.days.ago)
      product_stats_hash[:total] = overall_count(Product, FIRST_ORDER_DATE.created_at)
    product_stats_hash
  end


end
