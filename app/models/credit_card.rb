class CreditCard < ApplicationRecord
	belongs_to :customer, :class_name => "User", foreign_key: :user_id
	has_many :orders_placed, class_name: "Order", foreign_key: :credit_card_id
end
