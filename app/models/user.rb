class User < ApplicationRecord

  has_many :orders
  has_many :order_contents, through: :orders

  has_one :billing_address, :class_name => 'Address'
  has_one :shipping_address, :class_name => 'Address'
  has_many :credit_cards


  include SharedQueries


end
