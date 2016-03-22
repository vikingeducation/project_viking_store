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
      product_array << {category_id: product.category_id, category_name: Category.find(product.category_id).name}
      products << product_array
    end
    products
  end

  def self.created_since_days_ago(number)
    Product.all.where('created_at >= ?', number.days.ago).count
  end

end
