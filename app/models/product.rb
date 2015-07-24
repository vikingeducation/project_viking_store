class Product < ActiveRecord::Base

  def self.product_count(timeframe = 1000000)

    Product.where("created_at > ?", timeframe.days.ago).count

  end
end
