class Category < ActiveRecord::Base
  validates :description, presence: true
  validates :name, length: { minimum: 4, maximum: 16 }, presence: true
  has_many :products
  has_many :orders, through: :products
end
