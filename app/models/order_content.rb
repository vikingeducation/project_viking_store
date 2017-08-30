class OrderContent < ApplicationRecord
  # An OrderContent belongs to a single Order and Product.
  belongs_to :order
  belongs_to :product

  validates :order_id, uniqueness: { scope: :product_id }
end
