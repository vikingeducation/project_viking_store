class Category < ApplicationRecord

  has_many :products
  has_many :order_contents, :through => :products
  has_many :orders, :through => :order_contents

  validates :name, 
            :length =>{ :minimum => 4,
                        :maximum => 16 }, 
            :presence => true
end
