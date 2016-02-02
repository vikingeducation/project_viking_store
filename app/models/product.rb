class Product < ActiveRecord::Base
  def self.new_products_since(start_date)
    products = Product.where("created_at > '#{start_date}'").count
  end
end
