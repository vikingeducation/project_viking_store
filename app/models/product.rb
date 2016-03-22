class Product < ActiveRecord::Base

  belongs_to :category
  has_many :order_contents
  has_many :orders, :through => :order_contents

  def self.all_in_arrays
    products = []
    Product.all.each do |product|
      product_array = []
      product_array << product.id
      product_array << product.name
      product_array << product.price

      # Getting the category name and id
      product_array << {category_id: product.category_id, category_name: Product.category_name(product.category_id)}
      products << product_array
    end
    products
  end

  def self.created_since_days_ago(number)
    Product.all.where('created_at >= ?', number.days.ago).count
  end

  # Input a category_id, returns the category name.
  def self.category_name(category_id)
    Category.find(category_id).name
  end

  # Number of orders this product has been in, not the total sold.
  # order_contents table has order_id, product_id and quantity columns.
  # If I can get a count of all the rows that have the product_id I'm looking for, that'd be the answer.
  def self.times_ordered(product_id)
    OrderContent.where('product_id = ?', product_id).count
  end

end
