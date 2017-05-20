class User < ApplicationRecord
  validates :first_name, :last_name, :email,
            :length => {:in => 1..64}
  validates :email,
            :format => {:with => /.+@.+/}

  has_many :addresses
  has_many :orders
  has_many :credit_cards,
           :dependent => :destroy
  has_many :order_contents,
           :through => :orders
  has_many :products,
           :through => :order_contents,
           :source => :product
  belongs_to :default_billing_address,
             :class_name => "Address",
             :foreign_key => :billing_id
  belongs_to :default_shipping_address,
             :class_name => "Address",
             :foreign_key => :shipping_id
end
