class OrderContent < ApplicationRecord

  belongs_to :order
  has_many :products
  
end
