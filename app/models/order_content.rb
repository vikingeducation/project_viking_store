class OrderContent < ApplicationRecord

  belongs_to :order
  belongs_to :product

  validates :product_id, :quantity, presence: true

  def price
    product.price
  end

  def total_price
    price * quantity
  end

end
