class Address < ActiveRecord::Base
  has_many :billing_users, class_name: "User", foreign_key: :billing_id
  has_many :shipping_users, class_name: "User", foreign_key: :shipping_id

  belongs_to :user
  belongs_to :city
  belongs_to :state
end
