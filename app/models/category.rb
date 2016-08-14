class Category < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :length => { in: 4..16 }

  has_many :products, dependent: :nullify #getting rid of dependent nullify gets rid of error upon deleting an object
end
