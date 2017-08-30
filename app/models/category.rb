class Category < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 4, maximum: 16 }

  validates :description,
            presence: true,
            length: { minimum: 4, maximum: 140 }


  # A Category has many Products.
  # If we destroy a Category, we don't want to destroy its associated Products.
  has_many :products, dependent: :nullify

  # A Category has many OrderContents through its associated Products.
  # A Category thus has many Orders through OrderContents.
  has_many :order_contents, through: :products
  has_many :orders, through: :order_contents



  # Finds all Products that belong to a particular Category.
  # Orders by Product name.
  def products_in_category
    self.products.order(:name)
  end
end
