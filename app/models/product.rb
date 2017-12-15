class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents

  validates :name, :description, :category, presence: true
  validates :price, numericality: { less_than_or_equal_to: 10_000 }
  validates :sku, presence: :true,
                  uniqueness: true


  include SharedQueries

  def category_name
    category.name
  end

  def times_purchased
    Product.joins_product_to_orders(self.id).
            where('orders.checkout_date IS NOT NULL').
            count
  end

  def current_cart_count
    Product.joins_product_to_orders(self.id).
            where('orders.checkout_date IS NULL').
            count
  end

  def self.dropdown
    all.order('name ASC')
  end

  private

  def self.joins_product_to_orders(id)
    joins('JOIN order_contents ON products.id = order_contents.product_id').
    joins('JOIN orders on order_contents.order_id = orders.id').
    where('products.id = ?', id)
  end

end
