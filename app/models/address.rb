class Address < ActiveRecord::Base
  # You would not delete a user if you delete an address, since the key is on this side, you don't have to do anything. 
  belongs_to :user
  # You would not delete a city if you deleted an address, no action needed.
  belongs_to :city
  # You would not delete a state if you deleted an address, no action needed.
  belongs_to :state
  # You would not delete an order because you deleted an address, no action needed, but I guess you'd have to nullify it... The concept of having an order out there which has no address attached to it is annoying though, more of a general design issue though.
  has_many :orders_billed_to, :class_name => "Order", :foreign_key => :billing_id, :dependent => :nullify
  has_many :orders_shipped_to, :class_name => "Order", :foreign_key => :shipping_id, :dependent => :nullify
  validates :street_address, 
            :city_id, 
            :state_id, 
            :presence => true

end
