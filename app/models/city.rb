class City < ActiveRecord::Base
  has_many :addresses

  validates :name,  :presence => true,
                    :uniqueness => true
end
