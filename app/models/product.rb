class Product < ActiveRecord::Base
  def self.total
    Product.all.count
  end

  def self.new_products(t)
    Product.where("created_at > ?", Time.now - t*20*60*60)
  end
end
