class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents, :foreign_key => :order_id, :dependent => :nullify
  has_many :orders, :through => :order_contents

  validates :id, :name, :price, :category_id, :sku, :presence => true
  validates :price, :sku, :numericality => true
  validates :id, :uniqueness => true

  def self.times_ordered(id)
    Order.select('products.name, products.id, COUNT(products.id)').join_with_products.group('products.id').where("products.id=#{id}")
  end

  def self.carts_in(id)
    Order.select('products.name, products.id, COUNT(products.id)').join_with_products.group('products.id').where("products.id=#{id}").where('orders.checkout_date IS NULL')
  end

  def self.category(id)
    Product.select('id, name').where("category_id=#{id}")
  end

  def self.with_column_names
    Product.select('products.*, categories.name AS cat_name').joins('JOIN categories ON products.category_id = categories.id')
  end

  def self.total(num_days=nil)
    if num_days
      Product.where("created_at > ?", num_days.days.ago).count
    else
      Product.all.count
    end
  end
end
