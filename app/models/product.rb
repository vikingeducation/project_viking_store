class Product < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago

  def product_statistics
    product_stats_hash = {}
      product_stats_hash[:sevendays] = overall_count(Product, SEVEN_DAYS)
      product_stats_hash[:thirtydays] = overall_count(Product, THIRTY_DAYS)
      product_stats_hash[:total] = overall_count(Product, FIRST_ORDER_DATE.created_at)
    product_stats_hash
  end

  private

  def overall_count(model, num_days_ago)
    model.where('created_at >= ?', num_days_ago).count
  end


end
