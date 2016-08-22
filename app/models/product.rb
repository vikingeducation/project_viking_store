class Product < ApplicationRecord

  def self.new_products_7
    Product.where("created_at > '#{Time.now.to_date - 7}'").count
  end

  def self.new_products_30
    Product.where("created_at > '#{Time.now.to_date - 30}'").count
  end

end
