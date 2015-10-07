class Category < ActiveRecord::Base

    has_many :products, dependent: :delete_all
    validates :name,
            presence: true,
            uniqueness: true,
            allow_nil: false,
            length: {
              in: 4..16
            }
end
