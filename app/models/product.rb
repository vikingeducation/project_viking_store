class Product < ActiveRecord::Base
  def self.total
    Product.all.count
  end

  def self.new_products(t)
    Product.where("created_at > CURRENT_DATE - INTERVAL '#{t} DAYS' ").count
  end
end
