class OrderContent < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  validates :product, :quantity, :order,
    presence: true,
    numericality: { only_integer: true }

  def value
    quantity * self.product.price
  end

  def self.total_revenue
    OrderContent.joins(:product, :order).where("checkout_date IS NOT NULL").sum("quantity * price").to_f
  end
end
