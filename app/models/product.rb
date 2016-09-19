class Product < ActiveRecord::Base
  validates :name, :description, :price, :sku, :presence => true
  validates :price, numericality: { less_than: 10000 }

  has_many :order_contents
  has_many :orders, through: :order_contents
  belongs_to :category

  def self.total
    self.count
  end

  def self.new_products(days_since)
    self.where("created_at > '#{DateTime.now - days_since}'").count
  end

  def self.category(product_id)
    self.select("categories.id, categories.name")
        .join_with_categories
        .where("products.id = #{product_id}")
  end

  def self.num_orders(product_id)
    self.select("orders.id")
        .join_with_orders
        .where("orders.checkout_date IS NOT null AND products.id  = #{product_id}")
        .count
  end

  def self.num_carts(product_id)
    self.select("orders.id")
        .join_with_orders
        .where("orders.checkout_date IS null AND products.id  = #{product_id}")
        .count
  end

  def self.join_with_categories
    joins("JOIN categories ON categories.id = products.category_id")
  end

  def self.join_with_orders
    join_with_order_contents.join_order_with_order_contents
  end

  def self.join_with_order_contents
    joins("JOIN order_contents ON order_contents.product_id = products.id")
  end

  def self.join_order_with_order_contents
    joins("JOIN orders ON orders.id = order_contents.order_id")
  end
end
