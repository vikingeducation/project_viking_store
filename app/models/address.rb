class Address < ApplicationRecord
  belongs_to :user
  belongs_to :city
  belongs_to :state

  validates :street_address, :zip_code, presence: :true
  validates :street_address, length: {in: 1..64 }
  validates_associated :city

end
