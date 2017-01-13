class Address < ApplicationRecord
  validates :street_address, :user_id, :city_id, :state_id, :zip_code, :presence => true
  validates :street_address, :length => { maximum: 64 }
 
  belongs_to :state
  belongs_to :city
  belongs_to :user
  has_many :orders, foreign_key: :shipping_id, class_name: 'Order'

end
