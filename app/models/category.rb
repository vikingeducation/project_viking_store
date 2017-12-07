class Category < ApplicationRecord

  has_many :products

  validates :name,
            presence: true,
            length: {:in => 4..16}

end
