class Product < ActiveRecord::Base
  def self.total_products_listed
    Product.count()
  end
end
