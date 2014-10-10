class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :state
  belongs_to :city

  has_many :orders_billing_here,
           class_name: "Order",
           foreign_key: :billing_id

  has_many :orders_shipping_here,
           class_name: "Order",
           foreign_key: :shipping_id

  has_one :user_shipping_here,
           class_name: "User",
           foreign_key: :billing_id

  has_one :user_billing_here,
           class_name: "User",
           foreign_key: :shipping_id
end
