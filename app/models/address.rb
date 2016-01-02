class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  belongs_to :state

  has_one :user_default_shipping, foreign_key: :shipping_id, class_name: 'User'
  has_one :user_default_billing, foreign_key: :shipping_id, class_name: 'User'

  has_many :ship_to_orders, foreign_key: :shipping_id, class_name: 'Order'
  has_many :bill_to_orders, foreign_key: :billing_id, class_name: 'Order'
end
