class Address < ApplicationRecord
  belongs_to :user
  belongs_to :state
  belongs_to :city
  has_many :orders,
           :foreign_key => :shipping_id

  validates :street_address, :city_id, :state_id,
            :presence => true
  validates :street_address,
            :length => {:in => 1..64}

end
