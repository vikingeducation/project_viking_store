class Product < ApplicationRecord

  def product_stats
    product_stats_hash = {
      new_sevendays: Product.where('created_at >= ?', 7.days.ago).count
      new_thirtydays: Product.where('created_at >= ?', 30.days.ago).count
      total: Product.all.count
    }
  end


end
