class User < ApplicationRecord
	has_many :cards, class_name: "CreditCard", foreign_key: :user_id
	has_many :orders
	has_many :addresses
	has_one :default_shipping_address_id, class_name: "Address", foreign_key: :user_id
	has_one :default_billing_address_id, class_name: "Address", foreign_key: :user_id
	has_many :order_contents,
			 :through => :orders
	has_many :products, 
			 :through => :order_contents

	def self.past_days(n)
		User.where(:created_at => (Time.now - n.days)..Time.now)
	end
end