class Product < ApplicationRecord
  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents



  validates :price, :name, :description, :category_id, :sku, presence: true
  validates :sku, length: { is: 13 }
  validate :category_id_exists

  def category_id_exists
    unless Category.exists?(id: category_id)
      errors.add(:category_id, :category_id)
    end
  end

  def self.new_products_count(days_ago = 7, n = 0)
    products = Product.where("created_at <= current_date - '#{n * days_ago} days'::interval AND created_at > current_date - '#{(n + 1) * days_ago} days'::interval").count
  end

  def self.products_in_category(category_id)
    products = Product.where("category_id = #{category_id}")
  end

  def self.times_ordered(product_id)
    Order.join_orders_with_order_contents.where("checkout_date IS NOT NULL AND product_id = #{product_id}").count
  end

  def self.carts_in(product_id)
    Order.join_orders_with_order_contents.where("checkout_date IS NULL AND product_id = #{product_id}").count
  end
end
