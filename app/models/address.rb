class Address < ApplicationRecord

  belongs_to :user
  belongs_to :state
  belongs_to :city

  validates :street_address, length: {maximum: 64}
end
