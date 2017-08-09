class Product < ApplicationRecord
  
  def self.product_count
    Product.count 
  end

  def self.product_created(days)
    Product.where('created_at > ?',(Time.now - days.days)).count 
  end

  # def self.product_created_thirty_days
  #   Product.where('created_at > ?',(Time.now - 30.days)).count 
  # end

end
