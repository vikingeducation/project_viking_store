class OrderContent < ApplicationRecord
  # An OrderContent belongs to a single Order and Product.
  belongs_to :order
  belongs_to :product

  validates :order_id, uniqueness: { scope: :product_id }

  validates :order_id,
            :product_id,
            presence: true

  validates :quantity,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
