class Product < ApplicationRecord
  # calculates the number of new Products that were added within a number of
  # days from the current day
  def self.new_products(within_days)
    Product.where("created_at >= ? ", Time.now - within_days.days).count
  end

  # finds all Products that belong to a particular Category.
  # orders by Product name.
  def self.products_in_category(category_id)
    Product.where(category_id: category_id).order(:name)
  end

  # sets the category_id of all Products that belong to a
  # particular Category to nil, to disassociate the Product
  # from the Category when the Category is deleted
  def self.clear_products_category(category_id)
    products = Product.where(category_id: category_id)

    products.map { |product| product.update(category_id: nil) }
  end
end
