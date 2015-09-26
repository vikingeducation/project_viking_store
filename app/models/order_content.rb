class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  # Returns the revenue for this order
  def revenue
    (quantity * product.price).to_f
  end
end
