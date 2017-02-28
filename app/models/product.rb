class Product < ApplicationRecord
  belongs_to :category

  has_many :order_contents
  has_many :orders, through: :order_contents

  validates :name, :description, :sku, :price, :category_id, presence: true
  validates :sku, uniqueness: true
  validates :price, numericality: { greater_than: 1, less_than: 10000 }

  def get_order_count
    self.orders.where("checkout_date IS NOT NULL").count
  end

  def get_cart_count
    self.orders.where("checkout_date IS NULL").count
  end

  def self.get_num_of_new_products(start = Time.now, days_ago = nil)
    result = Product.select("count(*) AS num_new_products")
    unless days_ago.nil?
      result = result.where("products.created_at <= ? AND products.created_at >= ?", start, start - days_ago.days )
    end
    result[0].num_new_products.to_s
  end

end
