class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :state
  belongs_to :city

  has_many :default_shipping_address,
            class_name: "Address",
            through: :shipping_address,
            source: :user

  has_many :billed_orders,
            class_name: 'Order',
            foreign_key: :billing_id

  has_many :shipped_orders,
            class_name: 'Order',
            foreign_key: :shipping_id
end
