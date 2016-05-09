class Product < ActiveRecord::Base
  def self.total
    Product.all.count
  end
end
