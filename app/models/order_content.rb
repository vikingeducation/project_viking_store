class OrderContent < ActiveRecord::Base

  validates :product_id, uniqueness: { scope: :order_id }


  belongs_to :order
  belongs_to :product


end
