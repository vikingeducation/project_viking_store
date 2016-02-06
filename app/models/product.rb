class Product < ActiveRecord::Base

  has_many :order_contents
  has_many :orders, through: :order_contents,
            source: :order
  belongs_to :category



  validates :price, :name, :category_id,
            :presence => true

  validates :price,
            numericality: {less_than: 10000}


  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("created_at > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.find_category(product)
    self.select("categories.name AS name").
    joins("JOIN categories ON categories.id = products.category_id").
    where("products.id = #{product.id}")
  end

  def self.find_categories
    self.select("categories.name AS name, categories.id AS id").
    joins("JOIN categories ON categories.id = products.category_id").
    order("products.id")
  end

  def self.find_orders(product)
    self.select("COUNT(order_contents.id) as num_orders").
    joins("JOIN order_contents ON order_contents.product_id = products.id").
    joins("JOIN orders ON orders.id = order_contents.order_id").
    where("products.id = #{product.id} AND orders.checkout_date IS NOT NULL")
  end

  def self.find_cart_count(product)
    self.select("COUNT(order_contents.id) as cart_orders").
    joins("JOIN order_contents ON order_contents.product_id = products.id").
    joins("JOIN orders ON orders.id = order_contents.order_id").
    where("products.id = #{product.id} AND orders.checkout_date IS NULL")
  end
end
