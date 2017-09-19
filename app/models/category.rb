class Category < ApplicationRecord

  has_many :products
  validates :name, 
            :length =>{ :minimum => 4,
                        :maximum => 16 }, 
            :presence => true
end
