class Product < ActiveRecord::Base
  include Recentable
  belongs_to :category, inverse_of: :products
  has_many :order_contents
  has_many :orders, through: :order_contents
  validates :name, :sku, :price, :category_id, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 10000 }
  validates :category, presence: true

  def times_ordered
    order_contents.joins(:order).where("orders.checkout_date IS NOT NULL").count
  end

  def carts_in
    order_contents.joins(:order).where("orders.checkout_date IS NULL").count
  end

  def price=(value)
    value = value.to_s.tr('$', '').to_f
    write_attribute(:price, value)
  end
end
