class City < ActiveRecord::Base

  has_many :addresses

  validates :name,
            presence: true,
            uniqueness: true,
            allow_blank: false,
            allow_nil: false,
            length: {maximum: 140}

end
