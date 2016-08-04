class Category < ActiveRecord::Base
  validates :name,
            presence: true,
            length: { maximum: 16, minimum: 4 }


  def all_products
    Product.where("category_id = #{self.id}")
  end
end
