class Category < ApplicationRecord
  validates :name, presence: true, length: { in: 4..16 }

  has_many :products
end
