class Address < ApplicationRecord
  has_one :user, foreign_key: :shipping_id, primary_key: :id, dependent: :nullify
  has_one :user, foreign_key: :billing_id, primary_key: :id, dependent: :nullify
  belongs_to :city
  belongs_to :state
  has_many :orders, foreign_key: :billing_id, dependent: :nullify
  has_many :orders, foreign_key: :shipping_id, dependent: :nullify

  validates :street_address, :zip_code, presence: :true
  validates :street_address, length: {in: 1..64 }
  validates_associated :city

end
