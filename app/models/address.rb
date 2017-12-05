class Address < ApplicationRecord

  belongs_to :user
  belongs_to :state
  belongs_to :city
  has_many :orders, foreign_key: :billing_id
  accepts_nested_attributes_for :city

  validates :state_id, :user_id, :zip_code, presence: true
  validates :street_address, :city,
            presence: true,
            length: { maximum: 64,
                      minimum: 2 }
end
