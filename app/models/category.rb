class Category < ApplicationRecord
  validates :name, :presence => true,
                   :uniqueness => true,
                   :length => {:in => 4..16}
end
