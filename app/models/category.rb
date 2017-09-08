class Category < ApplicationRecord
   validates :name, 
            :length =>{ :minimum => 4,
                        :maximum => 16 }, 
            :presence => true
end
