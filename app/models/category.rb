class Category < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 4, maximum: 16 }

  validates :description,
            presence: true,
            length: { minimum: 4, maximum: 140 }

  # finds the Category name of a specific Product.
  def self.category_name(product)
    Category.find_by(id: product.category_id).name
  end
end
