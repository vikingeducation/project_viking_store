class City < ActiveRecord::Base
  has_many :addresses, dependent: :nullify

  validates :name, length: { in: 1..64 }
end
