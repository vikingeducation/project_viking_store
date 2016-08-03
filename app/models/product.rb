class Product < ActiveRecord::Base

  def self.product_count(time = nil)
    if time
      Product.where("created_at > ?", time.days.ago).count
    else
      Product.all.count
    end
  end
end
