class Category < ApplicationRecord
  validates :name, :presence => true,
                   :length => { within: 4..16 }
end
