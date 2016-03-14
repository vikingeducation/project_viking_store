class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :city
  belongs_to :state
  has_many :billings, :class_name => "Order", :foreign_key => :billing_id
  has_many :shippings, :class_name => "Order", :foreign_key => :shipping_id

end
