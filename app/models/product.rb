class Product < ActiveRecord::Base

  validates :title, presence: true
  validates :price, presence: true # TODO validate > 0 for float price
  validates :sku, presence: true
  validates :description, presence: true
  validates :category_id, presence: true

  has_many :order_contents
  has_many :orders, through: :order_contents

  belongs_to :category


  def self.products(time)
  	Product.where('created_at > ?',time).count
  end

  def times_ordered
    self.orders.where(is_placed: true).count
  end

  def carts_in
    self.orders.where(is_placed: false).count
  end
end
