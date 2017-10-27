class Product < ApplicationRecord

  include CountSince

  validates :price,
            format: { with: /[^$]/ }


  def self.product_statistics
    product_stats_hash = {}
    product_stats_hash[:sevendays] = count_since(7.days.ago)
    product_stats_hash[:thirtydays] = count_since(30.days.ago)
    product_stats_hash[:total] = count_since((Order.select(:created_at).first).created_at)
    product_stats_hash
  end


end
