class Product < ApplicationRecord

  def self.get_product_count(n_of_days = nil)
    return total_product_count unless n_of_days

    Product.where("created_at > NOW() - INTERVAL '? days'",
                  n_of_days).count
  end

  def self.total_product_count
    Product.count
  end
end
