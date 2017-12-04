class Order < ApplicationRecord

  belongs_to :user

  has_one :billing_address, :class_name => 'Address'
  has_one :shipping_address, :class_name => 'Address'

  has_many :order_contents, dependent: :destroy
  has_many :contents, foreign_key: 'order_id', class_name: 'OrderContent'

  has_many :products, through: :order_contents

end
