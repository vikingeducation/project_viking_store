class OrderContents < ActiveRecord::Base
  belongs_to :order
  belongs_to :product


  def increase_quantity(amount)
    self.update(:quantity => self.quantity + amount)
  end


end
