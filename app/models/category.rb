class Category < ActiveRecord::Base

  has_many :products, dependent: :destroy

  validates :name,
            presence: true,
            length: { in: 4..16 }
end
