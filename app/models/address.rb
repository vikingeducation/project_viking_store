class Address < ApplicationRecord
  belongs_to :user
  # note: setting the 'alias' on has_one seems to have helped Rails understand WHICH column to nullify on the User side of things
  has_one :as_billing, foreign_key: :billing_id, dependent: :nullify, class_name: 'User'
  has_one :as_shipping, foreign_key: :shipping_id, dependent: :nullify, class_name: 'User'
  belongs_to :city
  belongs_to :state
  has_many :orders, foreign_key: :billing_id, dependent: :nullify
  has_many :orders, foreign_key: :shipping_id, dependent: :nullify

  validates :street_address, :zip_code, presence: :true
  validates :street_address, length: {in: 1..64 }
  validates_associated :city

end
