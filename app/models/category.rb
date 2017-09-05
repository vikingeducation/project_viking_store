class Category < ApplicationRecord
   validates :title, 
            :length =>{ :minimum => 4,
                        :maximum => 16 }, 
            :presence => true
end
