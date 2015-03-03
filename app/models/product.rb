class Product < ActiveRecord::Base
  def self.number_of_products(number_of_days=nil)
    if number_of_days.nil?
      Product.where("created_at IS NOT NULL").count
    else
      Product.where("created_at > ?", number_of_days.days.ago).count
    end
  end

end
