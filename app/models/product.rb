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
    orders.where('orders.checkout_date IS NOT NULL').count
  end

  def current_cart_count
    orders.where('orders.checkout_date IS NULL').count
  end

  def self.dropdown
    all.order('name ASC')
  end

end
