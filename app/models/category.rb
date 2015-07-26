class Category < ActiveRecord::Base
  validates  :name, {:uniqueness => true , :presence => true}
  validates  :description, :presence => true

  def products
    Product.where(category_id: self.id)
  end
end
