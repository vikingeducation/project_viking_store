class Product < ApplicationRecord

  include CountSince

  FIRST_ORDER_DATE = Order.select(:created_at).first
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago

  def self.product_statistics
    product_stats_hash = {}
      product_stats_hash[:sevendays] = count_since(SEVEN_DAYS)
      product_stats_hash[:thirtydays] = count_since(THIRTY_DAYS)
      product_stats_hash[:total] = count_since(FIRST_ORDER_DATE.created_at)
    product_stats_hash
  end


end
