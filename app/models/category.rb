class Category < ActiveRecord::Base

  validates :name,
            :length => {:in => 4..16}

  def self.all_in_arrays
    categories_in_arrays = []
    Category.all.each do |category|
      category_array = []
      category_array << category.id
      category_array << category.name
      category_array << category.description
      category_array << category.created_at
      category_array << category.updated_at
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
      product_array << product.sku
      product_array << product.description
      product_array << product.price
      product_array << product.category_id
      product_array << product.created_at
      product_array << product.updated_at
      products << product_array
    end
    products
  end

=begin

  I made this to patch up the problems the method below was causing but now it's making problems with my Category.find method so I have to can it : (.

  def self.to_array
    rows = []
    Category.find_by_sql("SELECT * FROM categories").each do |category|
      row = []
      row << category.id
      row << category.name
      row << category.description
      row << category.created_at
      row << category.updated_at
      rows << row
    end
    rows
  end
=end

=begin

  I think this method is causing me a lot of deadlock, recursive locking issues even though I have no idea why.

  def self.column_names
    Product.find_by_sql("SELECT * FROM information_schema.columns where table_name='categories'")
  end
=end

end
