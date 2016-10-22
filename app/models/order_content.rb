class OrderContent < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, uniqueness: { scope: :order_id }

  def value
    product.price * quantity
  end
end
