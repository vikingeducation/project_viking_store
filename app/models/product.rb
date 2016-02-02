class Product < ActiveRecord::Base

  def self.new_products(n)
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end


  def self.total
    Product.select("name").distinct.count
  end
end
