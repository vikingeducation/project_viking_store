class Address < ApplicationRecord
  validates :street_address, :state_id, :presence => true
 
  belongs_to :state
  belongs_to :city
  belongs_to :user

end
