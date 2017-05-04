class Category < ApplicationRecord

  has_many :products

  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => {:in => 4..16}

end
