class Category < ActiveRecord::Base
  validates :name, :description, presence: true
  has_many :products
  has_many :orders, through: :products
end
