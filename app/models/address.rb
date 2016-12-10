class Address < ApplicationRecord
  belongs_to :city
  belongs_to :state
  has_many :users

end
