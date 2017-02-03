class Address < ApplicationRecord
	belongs_to :city
	belongs_to :state
	belongs_to :customer, :class_name => "User", foreign_key: :user_id
	belongs_to :user
end
