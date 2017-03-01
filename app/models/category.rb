class Category < ApplicationRecord
  has_many :products
  has_many :order_contents, through: :products
  has_many :orders, through: :order_contents

  validates :name, presence: true, length: { in: 4..16 }
  validates :id, uniqueness: true
end
