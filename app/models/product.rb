class Product < ApplicationRecord
  def self.new_products(within_days)
    Product.where("created_at > ? ", Time.now - within_days.days).count
  end
end
