class Category < ActiveRecord::Base
  validates :name, :presence => true

  has_many :products

  ###########
  has_many :orders, :through => :products
  #######3
end
