class Category < ActiveRecord::Base
  has_many :products
  has_many :orders, through: :products
end
