class Product < ActiveRecord::Base

  def self.last_seven_days
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").count
  end


end
