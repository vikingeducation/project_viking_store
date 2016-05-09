class Product < ActiveRecord::Base
  def self.total
    Product.all.count
  end

  def self.new_products(t)
    Product.where("created_at > ?", Time.now - t*24*60*60).count
  end
end
