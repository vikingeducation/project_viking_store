class Category < ActiveRecord::Base

  has_many :products

  validates :name,
            :presence => true,
            :length =>{:in => 4..16},
            :uniqueness => true



end
