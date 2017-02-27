class Product < ApplicationRecord

  def self.new_products_count(days_ago=7, n=0)
    products = Product.where("created_at <= current_date - '#{n * days_ago} days'::interval AND created_at > current_date - '#{(n + 1) * days_ago} days'::interval").count
  end

  def self.products_in_category(category_id)
    products = Product.where("category_id = #{category_id}")
  end
end
