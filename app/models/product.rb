class Product < ActiveRecord::Base

  def product_count(time)
    Product.select("COUNT(*) AS product_count").where("created_at > ?", time.days.ago)
  end
end
