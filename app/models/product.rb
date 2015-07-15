class Product < ActiveRecord::Base

  def self.count_new_products(day_range = nil)
    if day_range.nil?
      Product.all.count
    else
      Product.where("created_at > ?", Time.now - day_range.days).count
    end
  end


end
