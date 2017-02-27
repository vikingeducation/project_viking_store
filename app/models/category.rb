class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  
  validates :name, presence: true, length: { in: 4..16 }
end
