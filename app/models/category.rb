class Category < ActiveRecord::Base

  has_many :products

  validates :name,
            :length => {:in => 4..16}

  def self.all_in_arrays
    categories_in_arrays = []
    Category.all.each do |category|
      category_array = []
      category_array << category.id
      category_array << category.name
      categories_in_arrays << category_array
    end
    categories_in_arrays
  end

  def self.products_in_arrays(category_id)
    products = []
    Product.where(:category_id => category_id).each do |product|
      product_array = []
      product_array << product.id
      product_array << product.name
      products << product_array
    end
    products
  end

end
