class Product < ApplicationRecord
  belongs_to :category
  has_many :order_contents
  has_many :orders, :through => :order_contents

  validates :name, :description, :sku, :category_id, :price, :presence => true
  validates :price, :numericality => {:less_than_or_equal_to => 10_000}

  def self.number_of_carts(product_id)
    # products to order_contents to orders, make sure checkout date IS null
    Product.joins("AS p JOIN order_contents oc ON oc.product_id = p.id")
           .joins("JOIN orders o ON o.id = oc.order_id")
           .where("o.checkout_date IS NULL AND p.id = #{product_id}")
           .count("oc.product_id")
  end
end
