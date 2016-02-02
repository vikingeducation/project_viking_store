class Product < ActiveRecord::Base
  def self.total_products_listed
    Product.count()
  end

  def self.total_products_30
    Product.where("created_at > ( CURRENT_DATE - 30 )").count
  end
end
