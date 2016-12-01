class Product < ApplicationRecord

  def self.count_by_days(num_days)
    products = select('COUNT(*) AS p_count')
    products = products.where("created_at >= ?", num_days.days.ago) if num_days
    products[0].p_count
  end
end
