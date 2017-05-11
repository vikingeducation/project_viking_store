class City < ApplicationRecord

  has_many :addresses

  validates :name,
            :length => {:maximum => 64, 
                        :minimum => 2, 
                        message: 'City should be between 2 and 60 characters'},
            :uniqueness => true,
            allow_blank: false,
            presence: true

end
