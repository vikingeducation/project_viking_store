class Category < ActiveRecord::Base
  has_many :products

  validates :name,
            :presence => true,
            :uniqueness => true,
            :length => {
              :minimum => 4,
              :maximum => 16
            }

  validates :description,
            :presence => true,
            :length => {
              :minimum => 4
            }
end
