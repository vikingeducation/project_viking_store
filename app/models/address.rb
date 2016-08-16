class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user

  has_many :orders_billed_here, class_name: "Order", foreign_key: :billing_id
end
