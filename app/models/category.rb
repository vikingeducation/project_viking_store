class Category < ActiveRecord::Base
  has_many :products, inverse_of: :category, dependent: :nullify
  has_many :orders, through: :products, source: :orders

  validates :name, presence: true, length: { in: 4..16 }
end
