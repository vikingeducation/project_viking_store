class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  after_save :destroy_when_zero

  def increase_quantity(amount)

    self.update(:quantity => self.quantity + amount)

  end

  def total_cost

    self.quantity * self.product.price

  end

  def destroy_when_zero

    self.destroy if self.quantity == 0

  end
  
end
