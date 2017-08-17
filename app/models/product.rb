class Product < ApplicationRecord
  # calculates the number of new Products that were added within a number of
  # days from the current day
  def self.new_products(within_days)
    Product.where("created_at >= ? ", Time.now - within_days.days).count
  end
end
