class Product < ActiveRecord::Base

  has_many :order_contents, dependent: :destroy

  has_many :orders, :through => :order_contents

  belongs_to :category

  validates :name, :price, :sku, presence: true
  validates :price, numericality: true, inclusion: 1..10_000
  validates :sku, uniqueness: true

  self.per_page = 6

  def self.new_products(n)
    Product.all.where("created_at BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()").count
  end


  def self.total
    Product.select("name").distinct.count
  end

  def product_in_order(order_id)
    self.order_contents.where(:order_id => order_id)[0]
  end


  def self.times_ordered(product_id)
    # products to order_contents to orders, make sure checkout date is not null
    Product.joins("JOIN order_contents ON products.id = order_contents.product_id")
           .joins("JOIN orders ON orders.id = order_contents.order_id")
           .where("orders.checkout_date IS NOT NULL AND products.id = #{product_id}")
           .count("order_contents.product_id")
  end


  def self.number_of_carts(product_id)
    # products to order_contents to orders, make sure checkout date IS null
    Product.joins("AS p JOIN order_contents oc ON oc.product_id = p.id")
           .joins("JOIN orders o ON o.id = oc.order_id")
           .where("o.checkout_date IS NULL AND p.id = #{product_id}")
           .count("oc.product_id")
  end


end
