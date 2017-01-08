class Product < ApplicationRecord

  def self.total(num_days=nil)
    if num_days
      Product.where("created_at > ?", num_days.days.ago).count
    else
      Product.all.count
    end
  end
end
