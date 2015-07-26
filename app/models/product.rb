class Product < ActiveRecord::Base

  def self.product_count(timeframe = 1000000)

    Product.where("created_at > ?", timeframe.days.ago).count

  end

  def self.category_items(cat_id)
    Product.where("category_id = ?", cat_id).select("id, name")
  end

  def self.delete_category(cat_id)
    self.category_items(cat_id).each do |p|
      p.update(:category_id => nil)
    end
  end
end
