class OrderContent < ActiveRecord::Base

  belongs_to :order
  belongs_to :product

  def value
    product.price * quantity
  end

end
