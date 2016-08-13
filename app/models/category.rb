class Category < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :length => { in: 4..16 }

  has_many :products
end
