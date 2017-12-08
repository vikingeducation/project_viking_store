class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents

  validates :name, :sku, :description, :category, presence: true
  validates :price, numericality: { less_than_or_equal_to: 10_000 }


  include SharedQueries

  def category_name
    category.name
  end

  def times_purchased
    p_id = self.id
    Product.joins('JOIN order_contents ON products.id = order_contents.product_id').
            joins('JOIN orders on order_contents.order_id = orders.id').
            where('orders.checkout_date IS NOT NULL').
            where('products.id = ?', p_id).
            count
  end

  def current_cart_count
    p_id = self.id
    Product.joins('JOIN order_contents ON products.id = order_contents.product_id').
            joins('JOIN orders on order_contents.order_id = orders.id').
            where('orders.checkout_date IS NULL').
            where('products.id = ?', p_id).
            count
  end

end
