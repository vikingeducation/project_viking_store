class Address < ApplicationRecord
  belongs_to :user
  belongs_to :city
  belongs_to :state

  has_many :users_with_default_billing_address,
           :foreign_key => :billing_id,
           class_name: "User"

  has_many :users_with_default_shipping_address,
           :foreign_key => :shipping_id,
           class_name: "User"

  has_many :orders_with_billing_address,
           :foreign_key => :billing_id,
           class_name: "Order"

  has_many :orders_with_shipping_address,
           :foreign_key => :shipping_id,
           class_name: "Order"



end
