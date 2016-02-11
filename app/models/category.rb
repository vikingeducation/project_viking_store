class Category < ActiveRecord::Base

  has_many :products
  

  def self.find_products(category)
    self.select("products.name AS name, products.id AS id").
    joins("JOIN products ON products.category_id = categories.id").where("products.category_id = #{category.id}")
  end
end
