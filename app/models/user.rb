class User < ActiveRecord::Base
  has_one :billing, :class_name => 'Address'
  has_one :shipping, :class_name => 'Address'
  has_many :orders
  has_many :addresses
  has_many :credit_cards
end
