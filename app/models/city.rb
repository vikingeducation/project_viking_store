class City < ApplicationRecord

  has_many :addresses

  validates :name,
            :length => {:in => 3..64},
            :uniqueness => true,
            presence: true

end
