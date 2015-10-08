class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :quantity,
            :presence => true,
            :numericality => {:greater_than => 0}

  validates :order,
            :presence => true

  validates :product,
            :uniqueness => {:scope => [:order_id]},
            :presence => true

  # Returns the revenue for this order
  def revenue
    (quantity * product.price).to_f
  end
end
