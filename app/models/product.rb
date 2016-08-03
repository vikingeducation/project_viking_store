class Product < ActiveRecord::Base

  def product_count(time)
    Product.where("created_at > ?", time.days.ago)
  end
end
