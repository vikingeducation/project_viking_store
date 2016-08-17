class City < ActiveRecord::Base
  has_many :addresses

  validates :name, length: { maximum: 64 }
end
