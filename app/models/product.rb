class Product < ApplicationRecord

  def self.category(id)
    Product.select('id, name').where("category_id=#{id}")
  end

  def self.total(num_days=nil)
    if num_days
      Product.where("created_at > ?", num_days.days.ago).count
    else
      Product.all.count
    end
  end
end
