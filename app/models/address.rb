class Address < ActiveRecord::Base
  has_many :billing_users,  class_name: "User",
                            foreign_key: :billing_id
  has_many :shipping_users, class_name: "User",
                            foreign_key: :shipping_id

  has_many :billing_orders,  class_name: "Order",
                            foreign_key: :billing_id
  has_many :shipping_orders, class_name: "Order",
                            foreign_key: :shipping_id

  belongs_to :user
  belongs_to :city
  belongs_to :state

  accepts_nested_attributes_for :city
end
