class Category < ActiveRecord::Base
  validates  :name, :sku, {:uniqueness => true , :presence => true}
  validates  :description, :price, :presence => true

  def products
    Product.where(category_id: self.id)
  end
end
