class Address < ApplicationRecord

  belongs_to :user
  has_one :state
  has_one :city
  has_many :orders, foreign_key: :billing_id

end
