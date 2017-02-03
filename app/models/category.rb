class Category < ApplicationRecord

	has_many :products
	has_many :orders, 
			 :through => :products
			 
	validates 	:name,
				:presence => true,
            	:length =>{ :in => 4..16 } 
end