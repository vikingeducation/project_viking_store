class Address < ActiveRecord::Base
  belongs_to :user
  has_one :user_billing,  :foreign_key => 'billing_id',
                          :class_name => "User"
  has_one :user_shipping, :foreign_key => 'shipping_id',
                          :class_name => "User"
  belongs_to :city
  belongs_to :state



end
