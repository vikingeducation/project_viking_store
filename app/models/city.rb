class City < ApplicationRecord
  has_many :addresses
  has_many :users, through: :addresses

  validates :name, length: {in: 1..64 }, presence: true

end
