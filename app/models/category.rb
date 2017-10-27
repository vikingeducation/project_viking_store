class Category < ApplicationRecord

  validates :name,
            presence: true,
            length: { maximum: 16,
                      minimum: 4 }
end
