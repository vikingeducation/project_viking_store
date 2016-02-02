class Product < ActiveRecord::Base

  def self.last_seven_days
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").count
  end

  def self.last_thirty_days
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '30 days') AND NOW()").count
  end

  def self.total
    Product.select("name").distinct.count
  end
end
