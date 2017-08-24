class Category < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 4, maximum: 16 }

  validates :description,
            presence: true,
            length: { minimum: 4, maximum: 140 }

  # finds all Products that belong to a particular Category.
  # orders by Product name.
  def self.products_in_category(category_id)
    Product.where(category_id: category_id).order(:name)
  end
end
