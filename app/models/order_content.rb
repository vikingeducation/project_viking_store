class OrderContent < ApplicationRecord

  belongs_to :order
  belongs_to :product

  validates :product_id, 
            :uniqueness => {:scope => :order_id} #so there won't ever be two rows holding the same order_id and product_id altogether
  validates :quantity,
            numericality: {:greater_than_or_equal_to => 0}
  


end
