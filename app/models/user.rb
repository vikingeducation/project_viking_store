class User < ActiveRecord::Base
  has_many :addresses

  has_many :cities, :through => :addresses
  has_many :states, :through => :addresses

  has_many :orders

  belongs_to :default_billing_address, :class_name => "Address", :foreign_key => :billing_id

  belongs_to :default_shipping_address, :class_name => "Address", :foreign_key => :shipping_id

  ################
  has_many :products, :through => :orders

  has_many :credit_cards, :dependent => :delete_all

  ###############
end
