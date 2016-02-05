class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :state
  belongs_to :city

  has_many :orders_billed_here,
           class_name: "Order",
           foreign_key: :billing_id

  has_many :orders_shipped_here,
           class_name: "Order",
           foreign_key: :shipping_id

end
