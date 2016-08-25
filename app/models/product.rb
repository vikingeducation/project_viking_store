class Product < ApplicationRecord
  belongs_to :category

  has_many :order_contents, :destroy => :destroy
  has_many :orders,
           :through => order_contents

  def self.new_products_7
    Product.where("created_at > '#{Time.now.to_date - 7}'").count
  end

  def self.new_products_30
    Product.where("created_at > '#{Time.now.to_date - 30}'").count
  end

  def self.total_products
    Product.count
  end

  def self.belonged_category(id)
    Product.select("distinct categories.*").joins("JOIN categories ON categories.id = category_id").where("products.id = #{id}")
  end

  def self.all_orders(id)
    Product.select("*").joins("JOIN order_contents ON products.id = product_id").joins("
    JOIN orders ON order_id = orders.id").where("products.id = #{id}")
  end


  validates :name, :category_id, :price, :sku, presence: true
  validates :price, numericality: { only_float: true, less_than_or_equal_to: 10_000 }

end
